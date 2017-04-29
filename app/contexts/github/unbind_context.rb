class Github::UnbindContext < BaseContext
  before_perform :unbind_repo

  def initialize(github)
    @github = github
    @owner = @github.project.owner
  end

  def perform
    github_client = GithubService.new(@owner.full_access_token.value)
    return false unless github_client.permission_scopes.include?('admin:repo_hook')
    github_client.delete_hook(@github.repo_fullname, @github.hook_id)
    @github.destroy
  end
end
