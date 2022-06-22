class WebhooksController < BaseController
  skip_before_action :verify_authenticity_token
  before_action :find_github

  def webhook_data
    @mentions = Github::ReceiveCallbacksContext.new(@github, request: request, project: @project).perform
    render json: { mentions: @mentions }
  end

  private

  def find_github
    @github = Github.find_by(webhook_token: params[:token])
    @project = Project.all.select { |project| project.github_token == params[:token] }.first
    render json: { error: 'token not found' }, status: :not_found unless @github || @project
  end
end
