class SlackChannelCreateContext < BaseContext
  PERMITS = [:name, :webhook, :icon_url, :robot_name, :room, :primary, { events: [] }].freeze

  before_perform :validates_owner
  after_perform :set_primary

  def initialize(user, project)
    @project = project
    @user = user
  end

  def perform(params)
    @params = permit_params(params[:slack_channel] || params, PERMITS)
    @primary = @params.delete(:primary)
    run_callbacks :perform do
      @slack_channel = @project.slack_channels.new(@params)
      if @slack_channel.save
        @slack_channel
      else
        add_error(:data_create_fail, @slack_channel.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def validates_owner
    return add_error(:not_project_owner) unless @project.owner?(@user)

    true
  end

  def set_primary
    unless false?(@primary)
      @slack_channel.project.update(primary_slack_channel_id: @slack_channel.id)
    end
  end
end
