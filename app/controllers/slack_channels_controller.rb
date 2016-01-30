class SlackChannelsController < BaseController
  before_action :authenticate_user!
  before_action :find_project
  before_action :find_slack_channel

  def index
    @slack_channels = @project.slack_channels
  end

  def show
  end

  def new
    @slack_channel ||= @project.slack_channels.new
  end

  def edit
  end

  def create
    context = SlackChannelCreateContext.new(current_user, @project)
    if @slack_channel = context.perform(params)
      redirect_as_success project_slack_channels_path(@project), "Slack Channel created"
    else
      render_as_fail :new, context.error_messages
    end
  end

  def update
    context = SlackChannelUpdateContext.new(current_user, @slack_channel)
    if context.perform(params)
      redirect_as_success project_slack_channel_path(@project, @slack_channel), "Slack Channel updated"
    else
      render_as_fail :edit, context.error_messages
    end
  end

  def destroy
    context = SlackChannelDeleteContext.new(current_user, @slack_channel)
    if context.perform
      redirect_as_success project_slack_channels_path(@project), "Deleted"
    else
      redirect_as_fail project_slack_channels_path(@project), "Delete fail"
    end
  end

  def testing
    message = "test slack channel: #{@slack_channel.name}"
    context = Notify::SendToSlackContext.new(message, @slack_channel)
    if context.perform(async: false)
      redirect_as_success project_slack_channels_path(@project), "testing message send!"
    else
      redirect_as_fail project_slack_channels_path(@project), "testing failed! #{context.error_messages}"
    end
  end

  private

  def find_project
    @project = current_user.projects.find(params[:project_id])
  end

  def find_slack_channel
    @slack_channel = @project.slack_channels.find(params[:id]) if params[:id]
  end
end
