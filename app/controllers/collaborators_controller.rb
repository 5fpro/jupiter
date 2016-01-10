class CollaboratorsController < BaseController
  before_filter :project
  before_filter :project_user

  def index
    @project_users = project.project_users
  end

  def create
    if project_user.save
      redirect_to params[:redirect_to] || project_collaborators_path(project, project_user), flash: { success: "project_user created" }
    else
      new()
      flash.now[:error] = project_user.errors.full_messages
      render :new
    end
  end

  def destroy
    if project_user.destroy
      redirect_to params[:redirect_to] || project_collaborators_path, flash: { success: "project_user deleted" }
    else
      redirect_to :back, flash: { error: project_user.errors.full_messages }
    end
  end

  private

  def project
    @project = Project.find(params[:project_id])
  end

  def project_user
    @project_user ||= params[:id] ? @project.project_users.find(params[:id]) : @project.project_users.new(project_user_params)
  end

  def project_user_params
    params.fetch(:project_users, {}).permit(:user_id, :project_id)
  end
end
