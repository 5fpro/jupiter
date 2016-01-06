class Common::ProjectUpdateUsersCount < BaseContext
  def initialize(project)
    @project = project
  end

  def perform
    @project.update_attribute :users_count, @project.project_users.count
  end
end
