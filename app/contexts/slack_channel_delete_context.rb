class SlackChannelDeleteContext < BaseContext

  before_perform :validates_owner

  def initialize(user, slack_channel)
    @slack_channel = slack_channel
    @user = user
  end

  def perform
    run_callbacks :perform do
      @slack_channel.destroy
    end
  end

  private

  def validates_owner
    return add_error(:not_project_owner) unless @slack_channel.project.owner?(@user)

    true
  end
end
