class Github::BindContext < BaseContext
  PERMITS = [:repo_fullname, :webhook_name].freeze

  before_perform :build_github
  after_perform :create_webhook_token
  after_perform :binding_github
  after_perform :update_webhook_data

  def initialize(project, params)
    @project = project
    @owner = project.owner
    @params = permit_params(params[:github] || params, PERMITS)
  end

  def perform
    run_callbacks :perform do
      if @github.save!
        @github
      else
        add_error(:data_create_fail, @github.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def build_github
    @github = @project.githubs.new
    @github.repo_fullname = @params[:repo_fullname]
    @github.webhook_name = @params[:webhook_name]
  end

  def create_webhook_token
    Webhook::CreateTokenContext.new(@github).perform
  end

  def binding_github
    @webhook = ::GithubService.new(@owner.github_token).auto_create_hook(@params[:repo_fullname], webhook_url(@github.webhook_token))
  end

  def update_webhook_data
    @github.hook_id = @webhook.attrs[:id]
    @github.save
  end

  def webhook_url(token)
    "http://#{Setting.host}/webhooks/#{token}"
    # for ngrok test
    # "http://f8245dfa.ngrok.io/webhooks/#{token}"
  end
end
