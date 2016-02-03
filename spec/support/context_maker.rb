module ContextMaker
  def project_created!(user = nil)
    @user = user || FactoryGirl.create(:user)
    @project = UserCreateProjectContext.new(@user, attributes_for(:project, :update_project)).perform
    @project
  end

  def project_invite!(project = nil, user = nil)
    @project = project || project_created!
    @user = user || FactoryGirl.create(:user)
    ProjectInviteContext.new(@project.owner, @user.email, @project).perform
  end

  def record_created!(user, project)
    @record = RecordCreateContext.new(user, project).perform(attributes_for(:record))
  end
end
