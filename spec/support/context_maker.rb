module ContextMaker
  def project_created!(user = nil)
    @user = user || FactoryGirl.create(:user)
    @project = UserCreateProjectContext.new(@user, data_for(:project)).perform
  end
end
