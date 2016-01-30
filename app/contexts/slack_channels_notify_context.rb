class SlackChannelsNotifyContext < BaseContext
  before_perform :find_slack_channels

  def initialize(project, event)
    @project = project
    @event = event
  end

  def perform(objects = {})
    @objects = objects
    run_callbacks :perform do
      @slack_channels.each { |slack_channel| send_notify(@event, slack_channel, objects) }
    end
  end

  private

  def find_slack_channels
    @slack_channels = @project.slack_channels.select do |slack_channel|
      slack_channel.event?(@event)
    end
  end

  # TODO: move to another context
  def send_notify(event, slack_channel, objects = {})
    message = Notify::GenerateMessageContext.new(event, objects).perform
    Notify::SendToSlackContext.new(message, slack_channel).perform
  end
end
