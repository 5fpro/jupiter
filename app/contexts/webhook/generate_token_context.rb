class Webhook::GenerateTokenContext < BaseContext

  before_perform :generate_token

  def initialize(github)
    @github = github
    @project = github.project
  end

  def perform
    run_callbacks :perform do
      if @github.save!
        @github
      else
        add_error(:data_update_fail, @github.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def generate_token
    @github.assign_attributes(webhook_token: Digest::MD5.hexdigest(@github.id.to_s))
  end
end
