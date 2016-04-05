class WebhooksController < BaseController
  skip_before_action :verify_authenticity_token
  before_action :find_github

  def webhook_data
    render nothing: true, status: 200, content_type: 'text/html'
  end

  private

  def find_github
    @github = Github.find_by(webhook_token: params[:id])
  end
end
