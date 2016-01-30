class SlackChannelCreateContext < BaseContext
  PERMITS = [:name, :webhook, :icon_url, :robot_name, :room].freeze

  before_perform :build_slack_channel

  def initialize(project, params)
    @project = project
    @params = permit_params(params, PERMITS)
  end

  def perform
    run_callbacks :perform do
      return @slack_channel if @slack_channel.save
      add_error(:data_not_created, @slack_channel.errors.full_messages.join("\n"))
    end
  end

  private

  def build_slack_channel
    @slack_channel = @project.slack_channels.new(@params)
  end
end
