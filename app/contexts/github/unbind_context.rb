class Github::UnbindContext < BaseContext
  before_perform :unbind_repo

  def initialize(github)
    @github = github
    @owner = @github.project.owner
  end

  def perform
    begin
      GithubService.new(@owner.full_access_token.value).delete_hook(@github.repo_fullname, @github.hook_id)
    rescue
    end
    @github.destroy
  end
end
