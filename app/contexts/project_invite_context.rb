class ProjectInviteContext < BaseContext
  before_perform :validates_me_in_project!
  before_perform :validates_user_is_not_me!

  def initialize(me, user, project)
    @me = me
    @user = user
    @project = project
  end

  def perform
    run_callbacks :perform do
      ProjectAddUserContext.new(@project, @user).perform
    end
  end

  private

  def validates_me_in_project!
    return add_error(:user_is_not_in_project) unless @project.has_user?(@me)
    true
  end

  def validates_user_is_not_me!
    return add_error(:user_cant_be_self) if @me.id == @user.id
    true
  end
end
