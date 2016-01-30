class SlackChannelUpdateContext < BaseContext
  PERMITS = SlackChannelCreateContext::PERMITS

  before_perform :validates_owner
  before_perform :assign_attributes

  def initialize(user, slack_channel)
    @user = user
    @slack_channel = slack_channel
  end

  def perform(params)
    @params = permit_params(params[:slack_channel] || params, PERMITS)
    run_callbacks :perform do
      return @slack_channel if @slack_channel.save
      add_error(:data_not_updated, @slack_channel.errors.full_messages.join("\n"))
    end
  end

  private

  def validates_owner
    return add_error(:user_is_not_owner) if @slack_channel.project.owner_id != @user.id
    true
  end

  def assign_attributes
    @slack_channel.assign_attributes @params
  end
end
