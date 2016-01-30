class SlackChannelUpdateContext < BaseContext
  PERMITS = SlackChannelCreateContext::PERMITS

  before_perform :assign_attributes

  def initialize(slack_channel, params)
    @slack_channel = slack_channel
    @params = permit_params(params, PERMITS)
  end

  def perform
    run_callbacks :perform do
      return @slack_channel if @slack_channel.save
      add_error(:data_not_updated, @slack_channel.errors.full_messages.join("\n"))
    end
  end

  private

  def assign_attributes
    @slack_channel.assign_attributes @params
  end
end
