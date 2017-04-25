class WebhooksController < BaseController
  skip_before_action :verify_authenticity_token
  before_action :find_github

  def webhook_data
    @event = request.headers.to_h['HTTP_X_GITHUB_EVENT']
    @mentions = Github::ReceiveCallbacksContext.new(@github, @event, params).perform
    render json: { mentions: @mentions }
  end

  private

  def find_github
    @github = Github.find_by(webhook_token: params[:id])
  end
end
