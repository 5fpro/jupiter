class Github::BindContext < BaseContext
  PERMITS = [:repo_fullname].freeze

  def initialize(project, params)
    @project = project
    @owner = project.owner
    @params = permit_params(params[:github] || params, PERMITS)
  end

  def perform
    @github = @project.githubs.new(@params)
    @github.webhook_token = generate_webhook_token
    if bind_github
      save_github
    else
      add_error(:data_create_fail, 'github webhook create fail')
    end
  end

  private

  def generate_webhook_token
    token = nil
    while !token || Github.where(webhook_token: token).count > 0
      token = Digest::MD5.hexdigest(Time.now.to_f.to_s)
    end
    token
  end

  def bind_github
    @webhook = ::GithubService.new(@owner.full_access_token.value).create_hook(@params[:repo_fullname], @github.webhook_url)
    if @webhook
      @github.hook_id = @webhook.attrs[:id]
    else
      false
    end
  end

  def save_github
    if @github.save
      @github
    else
      add_error(:data_create_fail, @github.errors.full_messages.join("\n"))
    end
  end
end
