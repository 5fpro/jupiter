class SlackChannelCreateContext < BaseContext
  PERMITS = [:name, :webhook, :icon_url, :robot_name, :room].freeze

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
      add_error(:data_not_created, @slack_channel.errors.full_messages.join("\n"))
    end
  end

  private

  def build_slack_channel
    @slack_channel = @project.slack_channels.new(@params)
  end

  def validates_owner
    return add_error(:user_is_not_owner) if @project.owner_id != @user.id
    true
  end
end
