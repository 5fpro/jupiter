class Github::ReceiveCallbacksContext < ::BaseContext
  before_perform :init_vars!
  before_perform :find_action_type
  before_perform :find_sender
  before_perform :find_target
  before_perform :find_mentions
  before_perform :remove_self_notify!

  def initialize(github, request:)
    @github = github
    @request = request
    @event = request.headers.to_h['HTTP_X_GITHUB_EVENT']
    @action = request.request_parameters['action'] || request.query_parameters['action']
    @params = request.params
  end

  def perform
    run_callbacks :perform do
      @mentions.each do |slack_user|
        send_notification(slack_user)
      end
    end
    @mentions
  end

  private

  def init_vars!
    @project = @github.project
    @project_users = @project.project_users
    @params = JSON.parse(@params[:payload]).deep_symbolize_keys if @params[:payload]
  end

  def find_action_type
    @action ||= @params[:webhook].try(:[], :action)
    if @event.index('comment')
      @action_type = 'comment'
    elsif @action == 'submitted' && @event == 'pull_request_review'
      @action_type = 'submitted_pull_request_review'
    elsif @action == 'opened' && @event == 'pull_request'
      @action_type = 'opened_pull_request'
    elsif @action == 'opened' && @event == 'issues'
      @action_type = 'opened_issue'
    end
  end

  def find_sender
    @sender = @params[:sender][:login]
  end

  def find_target
    @target = {}
    if @action_type == 'comment'
      @target[:summary] = strip_body(@params[:comment][:body])
      @target[:body] = @params[:comment][:body]
      @target[:url] = @params[:comment][:html_url]
      @target[:message] = "你有新的回應: #{@target[:summary]}"
    elsif @action_type == 'submitted_pull_request_review'
      @target[:summary] = strip_body(@params[:review][:body])
      @target[:body] = @params[:review][:body]
      @target[:url] = @params[:review][:html_url]
      @target[:message] = "你有新的 code review: #{@target[:summary]}"
    elsif @action_type == 'opened_issue'
      @target[:summary] = strip_body(@params[:issue][:title])
      @target[:body] = @params[:issue][:body]
      @target[:url] = @params[:issue][:html_url]
      @target[:message] = "你在新的票被提及: #{@target[:summary]}"
    elsif @action_type == 'opened_pull_request'
      @target[:summary] = strip_body(@params[:pull_request][:title])
      @target[:body] = @params[:pull_request][:body]
      @target[:url] = @params[:pull_request][:html_url]
      @target[:message] = "你在新的 PR 被提及: #{@target[:summary]}"
    else # disabled
      object = @params[:issue] || @params[:pull_request] || {}
      @target[:summary] = object[:title]
      # @target[:body] = "@" + object[:assignee][:login]
      @target[:body] = '' # disable assignee
      @target[:url] = object[:html_url]
      @target[:message] = "你有新的指派: #{@target[:summary]}"
    end
  end

  def find_mentions
    mapping = generate_github_slack_user_mapping
    @mentions = []
    if @target[:body].present?
      mapping.each do |github_user, slack_user|
        @mentions << slack_user if @target[:body].index('@' + github_user)
      end
    end
  end

  def remove_self_notify!
    @mentions.reject! { |github_user, _| github_user == @sender }
  end

  def send_notification(slack_user)
    message = @target[:message] + " ......#{SlackService.render_link(@target[:url], '點擊查看')}"
    Notify::SendToUserContext.new(@project, slack_user, message).perform(async: false)
  end

  def generate_github_slack_user_mapping
    mapping = @project.project_users.includes(:user).inject({}) do |s, project_user|
      s.merge(project_user.user.github_account => project_user.slack_user)
    end
    mapping.merge!(project_json_mapping)
    mapping.select { |_, v| v.present? }
  end

  def project_json_mapping
    mapping = begin
                JSON.parse(@project.github_slack_users_mapping_json)
              rescue
                nil
              end
    return {} unless mapping.is_a?(Array)
    mapping.inject({}) { |a, e| a.merge(e.first => e.last) }
  end

  def strip_body(body)
    body.to_s.strip.tr("\n", '').tr("\r", '').tr("\t", '')
  end
end
