class WebhooksController < BaseController
  skip_before_filter :verify_authenticity_token
  before_filter :find_github

  def webhook_data
    puts @github.project.inspect
    render nothing: true, status: 200, content_type: 'text/html'
  end

  private

  def find_github
    @github = Github.find_by(webhook_token: params[:id])
  end
end
