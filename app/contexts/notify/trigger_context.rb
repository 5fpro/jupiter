class Notify::TriggerContext < BaseContext
  before_perform :find_slack_channels
  before_perform :generate_message

  def initialize(project, event)
    @project = project
    @event = event
  end

  def perform(objects = {})
    @objects = objects
    run_callbacks :perform do
      @slack_channels.each { |slack_channel| Notify::SendToSlackContext.new(@message, slack_channel).perform }
    end
  end

  private

  def find_slack_channels
    @slack_channels = @project.slack_channels.select do |slack_channel|
      slack_channel.event?(@event)
    end
  end

  def generate_message
    @message = Notify::GenerateMessageContext.new(@event, @objects).perform
  end
end
