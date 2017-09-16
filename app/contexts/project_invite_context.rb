class ProjectInviteContext < BaseContext
  before_perform :validates_user_exist!
  before_perform :validates_me_in_project!
  before_perform :validates_user_in_project!
  before_perform :validates_user_is_not_me!

  def initialize(me, email, project)
    @me = me
    @email = email
    @project = project
  end

  def perform
    run_callbacks :perform do
      Common::ProjectAddUserContext.new(@project, @user).perform
    end
  end

  private

  def validates_user_exist!
    @user = User.exists?(email: @email) ? User.find_by(email: @email) : nil
    return add_error(:data_not_found, "User not found email: #{@email}") unless @user
    true
  end

  def validates_me_in_project!
    return add_error(:user_is_not_in_project, '@me is not in project') unless @project.has_user?(@me)
    true
  end

  def validates_user_in_project!
    return add_error(:user_already_in_project) if @project.has_user?(@user)
    true
  end

  def validates_user_is_not_me!
    return add_error(:cant_do_for_yourself, 'invite') if @me.id == @user.id
    true
  end
end
