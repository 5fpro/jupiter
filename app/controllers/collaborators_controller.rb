class CollaboratorsController < BaseController
  before_action :authenticate_user!
  before_action :project
  before_action :project_user

  def index
    @project_users = project.project_users
  end

  def new
  end

  def create
    context = ProjectInviteContext.new(current_user, params[:project_user][:email], @project)
    if context.perform
      redirect_as_success(project_path(project), "project_user created")
    else
      render_as_fail(:new, context.error_messages)
    end
  end

  def destroy
    context = ProjectRemoveUserContext.new(current_user, @project_user.user, @project)
    if context.perform
      redirect_as_success(project_path(@project), "project_user deleted")
    else
      redirect_to :back, flash: { error: context.error_messages.join(",") }
    end
  end

  private

  def project
    @project = Project.find(params[:project_id])
  end

  def project_user
    @project_user ||= params[:id] ? @project.project_users.find(params[:id]) : nil
  end
end
