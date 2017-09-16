class UserProjectsQuery
  def initialize(user)
    @user = user
  end

  def query(archived: false)
    @user.project_users.public_send(archived ? 'archived' : 'unarchived').sorted.includes(:project).map(&:project)
  end
end
