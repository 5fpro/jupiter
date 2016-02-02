class ProjectUsersController < BaseController
  before_action :authenticate_user!
  before_action :find_project_users

  def update
    if @project_user.update_attributes(project_user_params)
      redirect_as_success(sorting_projects_path(@project), "Project Sorting Updated")
    else
      redirect_as_fail(sorting_projects_path(@project), "Project Sorting Updated failed")
    end
  end

  private

  def find_project_users
    @project_user ||= current_user.project_users.find(params[:id]) if params[:id]
  end

  def project_user_params
    params.fetch(:project_user, {}).permit(:sort)
  end
end
