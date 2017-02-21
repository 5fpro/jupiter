class Github
  class ReceiveCallbacksContext < ::BaseContext
    before_perform :init_vars!
    before_perform :find_action_type
    before_perform :find_sender
    before_perform :find_target
    before_perform :find_mentions
    before_perform :remove_self_notify!

    ACCEPTED_ACTIONS = ["created", "assigned"].freeze

    def initialize(github, callback_params)
      @github = github
      @params = callback_params
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
    end

    def find_action_type
      @action_type = @params[:webhook][:action]
      return false unless ACCEPTED_ACTIONS.include?(@action_type)
    end

    def find_sender
      @sender = @params[:sender][:login]
    end

    def find_target
      @target = {}
      if @action_type == "created" && @params[:comment]
        @target[:summary] = @params[:comment][:body].to_s.strip.tr("\n", "").tr("\r", "").tr("\t", "")
        @target[:body] = @params[:comment][:body]
        @target[:url] = @params[:comment][:html_url]
        @target[:message] = "你有新的回應: #{@target[:summary]}"
      elsif @action_type == 'submitted' && @params[:review]
        @target[:summary] = @params[:review][:body].to_s.strip.tr("\n", "").tr("\r", "").tr("\t", "")
        @target[:body] = @params[:review][:body]
        @target[:url] = @params[:review][:html_url]
        @target[:message] = "你有新的 code review: #{@target[:summary]}"
      else # disabled
        object = @params[:issue] || @params[:pull_request]
        @target[:summary] = object[:title]
        # @target[:body] = "@" + object[:assignee][:login]
        @target[:body] = "" # disable assignee
        @target[:url] = object[:html_url]
        @target[:message] = "你有新的指派: #{@target[:summary]}"
      end
    end

    def find_mentions
      mapping = generate_github_slack_user_mapping
      @mentions = []
      if @target[:body].present?
        mapping.each do |github_user, slack_user|
          @mentions << slack_user if @target[:body].index("@" + github_user)
        end
      end
    end

    def remove_self_notify!
      @mentions.reject! { |github_user, _| github_user == @sender }
    end

    def send_notification(slack_user)
      message = @target[:message] + " ......#{SlackService.render_link(@target[:url], "點擊查看")}"
      Notify::SendToUserContext.new(@project, slack_user, message).perform(async: false)
    end

    def generate_github_slack_user_mapping
      mapping = @project.project_users.includes(:user).inject({}) do |s, project_user|
          s.merge(project_user.user.github_account => project_user.slack_user)
      end
      mapping.merge!(project_json_mapping)
      mapping.select { |k, v| v.present? }
    end

    def project_json_mapping
      mapping = JSON.parse(@project.github_slack_users_mapping_json) rescue nil
      return {} unless mapping.is_a?(Array)
      mapping.inject({}) { |s, e| s.merge(e.first => e.last) }
    end
  end
end
