class Notify::SendToSlackContext < BaseContext
  before_perform :to_params
  before_perform :validates

  def initialize(message, slack_channel)
    @message = message
    @slack_channel = slack_channel
  end

  def perform(async: true)
    run_callbacks :perform do
      method = async ? :notify_async : :notify
      SlackService.public_send(method, @message, @params)
    end
  end

  private

  def to_params
    @params = {
      channel: @slack_channel.room,
      name: @slack_channel.robot_name,
      icon_url: @slack_channel.icon_url,
      webhook: @slack_channel.webhook
    }.select { |_, v| v.present? }
  end

  def validates
    return add_error(:params_required, 'no webhook') if @params[:webhook].blank?
    return add_error(:params_required, 'no channel') if @params[:channel].blank?

    true
  end
end
