class SlackChannelCreateContext < BaseContext
  PERMITS = [:name, :webhook, :icon_url, :robot_name, :room, { events: [] }].freeze

  before_perform :validates_owner
  before_perform :build_slack_channel

  def initialize(user, project)
    @project = project
    @user = user
  end

  def perform(params)
    @params = permit_params(params[:slack_channel] || params, PERMITS)
    run_callbacks :perform do
      return @slack_channel if @slack_channel.save
      add_error(:data_create_fail, @slack_channel.errors.full_messages.join("\n"))
    end
  end

  private

  def build_slack_channel
    @slack_channel = @project.slack_channels.new(@params)
  end

  def validates_owner
    return add_error(:not_project_owner) unless @project.owner?(@user)
    true
  end
end
