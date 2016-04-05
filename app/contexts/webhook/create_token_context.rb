class Webhook::CreateTokenContext < BaseContext

  before_perform :generate_webhook_url

  def initialize(github)
    @github = github
    @project = github.project
  end

  def perform
    run_callbacks :perform do
      return @github if @github.save!
      add_error(:data_update_fail, @github.errors.full_messages.join("\n"))
    end
  end

  private

  def generate_webhook_url
    @github.assign_attributes(webhook_token: Digest::MD5.hexdigest(@github.id.to_s))
  end
end
