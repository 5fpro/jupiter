module ContextMaker
  def project_invite!(project = nil, user = nil)
    @project = project || FactoryGirl.create(:project, :with_project_user)
    @user = user || FactoryGirl.create(:user)
    ProjectInviteContext.new(@project.owner, @user.email, @project).perform
  end

  def record_created!(user, project)
    @record = RecordCreateContext.new(user, project).perform(attributes_for(:record))
  end
end
