class Notify::SendToUserContext < BaseContext
  before_perform :find_slack_channel
  before_perform :find_slack_user
  before_perform :to_params

  def initialize(project, user_or_slack_user, message)
    @project = project
    if user_or_slack_user.is_a?(User)
      @user = user_or_slack_user
    else
      @slack_user = user_or_slack_user
    end
    @message = message
  end

  def perform(async: true)
    run_callbacks :perform do
      method = async ? :notify_async : :notify
      SlackService.public_send(method, @message, @params)
    end
  end

  private

  def find_slack_channel
    @slack_channel = @project.primary_slack_channel
    return add_error(:data_not_found, "Slack channel not found") unless @slack_channel
  end

  def find_slack_user
    return true if @slack_user
    project_user = @project.project_users.where(user_id: @user.id).first
    return add_error(:data_not_found, "project_user not found") unless project_user
    @slack_user = project_user.slack_user
    return add_error(:value_blank, "slack user should be presence") if @slack_user.blank?
  end

  def to_params
    @params = {
      channel: "@#{@slack_user}",
      name: @slack_channel.robot_name,
      icon_url: @slack_channel.icon_url,
      webhook: @slack_channel.webhook
    }.select { |_, v| v.present? }
  end
end
