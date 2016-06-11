class Github
  class NotifyMentionedUserContext < ::BaseContext
    before_perform :init_vars!
    before_perform :find_action_type
    before_perform :find_sender
    before_perform :find_target
    before_perform :find_mentions

    ACCEPTED_ACTIONS = ["created", "assigned"].freeze

    def initialize(github, params)
      @github = github
      @params = params
    end

    def perform
      run_callbacks :perform do
        @mentions.each do |user|
          send_notification(user)
        end
      end
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
        @target[:summary] = @params[:comment][:body][0..100]
        @target[:body] = @params[:comment][:body]
        @target[:url] = @params[:comment][:html_url]
        @target[:message] = "你有新的回應: #{@target[:summary]}..."
      else
        object = @params[:issue] || @params[:pull_request]
        @target[:summary] = object[:title]
        @target[:body] = "@" + object[:assignee][:login]
        @target[:url] = object[:html_url]
        @target[:message] = "你有新的指派: #{@target[:summary]}..."
      end
    end

    def find_mentions
      @mentions = []
      if @target[:body]
        @project.project_users.includes(:user).each do |project_user|
          user = project_user.user
          if project_user.slack_user.present?
            @mentions << user if @target[:body].index("@" + user.github_account)
          end
        end
      end
      @mentions.reject! { |user| user.github_account == @sender }
    end

    def send_notification(user)
      message = @target[:message] + ".......#{SlackService.render_link(@target[:url], "點擊查看")}"
      Notify::SendToUserContext.new(@project, user, message).perform(async: false)
    end
  end
end
