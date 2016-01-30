class SlackChannelsNotifyContext < BaseContext
  include RecordHelper

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
    message = generate_message(event, objects)
    send_to_slack(slack_channel, message)
  end

  def generate_message(event, objects = {})
    case event.to_s
    when "record_created" then I18n.t("messages.slack_channel.events.#{event}", record_id: objects[:record].id, user_name: objects[:record].user.name, time:  render_hours(objects[:record].total_time), record_type_name: record_type_name(objects[:record].record_type), project_name: objects[:record].project.name)
    end
  end

  def send_to_slack(slack_channel, message)
    name = slack_channel.robot_name
    icon_url = slack_channel.icon_url || ""
    webhook = slack_channel.webhook
    SlackService.notify_async(message, channel: slack_channel.room, name: name, icon_url: icon_url, webhook: webhook)
  end
end
