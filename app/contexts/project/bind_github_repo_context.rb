class Project::BindGithubRepoContext < BaseContext
  PERMITS = [:repo_fullname, :hook_url].freeze

  before_perform :bind_repo
  before_perform :assign_repo_data

  def initialize(project)
    @project = project
    @owner = project.owner
  end

  def perform(params)
    @params = permit_params(params[:project] || params, PERMITS)
    run_callbacks :perform do
      if @project.changed?
        @project.save!
      else
        add_error(:data_update_fail, @project.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def bind_repo
    @webhook = ::GithubService.new(@owner.github_token).auto_create_hook(@params[:repo_fullname], @params[:hook_url])
  end

  def assign_repo_data
    @project.data["repo_fullname"] = @params[:repo_fullname]
    @project.data["hook_id"] = @webhook.attrs[:id]
    @project.data["hook_url"] = @params[:hook_url]
  end
end
