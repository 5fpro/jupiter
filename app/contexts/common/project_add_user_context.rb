class Common::ProjectAddUserContext < BaseContext
  before_perform :validates_user_not_in_project!
  after_perform :update_users_count

  def initialize(project, user)
    @project = project
    @user = user
  end

  def perform
    run_callbacks :perform do
      @project.project_users.create(user: @user)
    end
  end

  private

  def validates_user_not_in_project!
    return add_error(:user_already_in_project) if @project.has_user?(@user)
  end

  def update_users_count
    Common::ProjectUpdateUsersCount.new(@project).perform
  end
end
