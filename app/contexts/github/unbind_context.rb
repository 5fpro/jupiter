class Github::UnbindContext < BaseContext
  before_perform :unbind_repo

  def initialize(github)
    @github = github
    @owner = @github.project.owner
  end

  def perform
    run_callbacks :perform do
      return true if @github.destroy
      add_error(:data_delete_fail, @project.errors.full_messages.join("\n"))
    end
  end

  private

  def unbind_repo
    GithubService.new(@owner.github_token).auto_delete_hook(@github.repo_fullname, @github.hook_id)
  end
end
