class Github::UnbindContext < BaseContext
  before_perform :unbind_repo

  def initialize(github)
    @github = github
    @owner = @github.project.owner
  end

  def perform
    token = @owner.full_access_token.value
    github_client = GithubService.new(token)
    return false unless token && github_client.permission_scopes.include?('admin:repo_hook')

    github_client.delete_hook(@github.repo_fullname, @github.hook_id) if @github.hook_id.present?
    @github.destroy
  end
end
