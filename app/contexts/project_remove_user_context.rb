class ProjectRemoveUserContext < BaseContext
  before_perform :validates_owner!
  before_perform :validates_user!
  before_perform :validates_is_not_self!
  after_perform :update_users_count

  def initialize(owner, user, project)
    @owner = owner
    @project = project
    @user = user
  end

  def perform
    run_callbacks :perform do
      @project.project_users.where(user_id: @user.id).first.destroy
    end
  end

  private

  def validates_owner!
    return add_error(:user_is_not_owner) unless @project.owner_id == @owner.id
    true
  end

  def validates_user!
    return add_error(:user_is_not_in_project) unless @project.has_user?(@user)
    true
  end

  def validates_is_not_self!
    return add_error(:user_cant_be_self) if @owner.id == @user.id
    true
  end

  def update_users_count
    Common::ProjectUpdateUsersCount.new(@project).perform
  end
end
