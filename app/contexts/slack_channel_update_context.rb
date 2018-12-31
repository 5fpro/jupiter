class SlackChannelUpdateContext < BaseContext
  PERMITS = SlackChannelCreateContext::PERMITS

  before_perform :validates_owner
  before_perform :assign_attributes
  after_perform :set_primary!

  def initialize(user, slack_channel)
    @user = user
    @slack_channel = slack_channel
  end

  def perform(params)
    @params = permit_params(params[:slack_channel] || params, PERMITS)
    run_callbacks :perform do
      if @slack_channel.save
        @slack_channel
      else
        add_error(:data_update_fail, @slack_channel.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def validates_owner
    return add_error(:not_project_owner) unless @slack_channel.project.owner?(@user)

    true
  end

  def assign_attributes
    @set_primary = @params.delete(:primary)
    @slack_channel.assign_attributes @params
  end

  def set_primary!
    if !false?(@set_primary)
      @slack_channel.project.update_attribute :primary_slack_channel_id, @slack_channel.id
    elsif @slack_channel.primary?
      @slack_channel.project.update_attribute :primary_slack_channel_id, nil
    end
  end
end
