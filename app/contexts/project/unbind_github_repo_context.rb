class Project::UnbindGithubRepoContext < BaseContext
  before_perform :unbind_repo
  before_perform :remove_repo_data

  def initialize(project)
    @project = project
    @owner = project.owner
  end

  def perform
    run_callbacks :perform do
      if @project.changed?
        @project.save!
      else
        add_error(:data_update_fail, @project.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def unbind_repo
    ::GithubService.new(@owner.github_token).auto_delete_hook(@project.repo_fullname, @project.hook_id)
  end

  def remove_repo_data
    @project.data["repo_fullname"] = nil
    @project.data["hook_id"] = nil
    @project.data["hook_url"] = nil
  end
end
