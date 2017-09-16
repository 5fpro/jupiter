class ProjectUsersController < BaseController
  before_action :authenticate_user!
  before_action :find_project_user

  def update
    if @project_user.update_attributes(project_user_params)
      redirect_as_success(edit_projects_path, 'Projects Updated')
    else
      redirect_as_fail(edit_projects_path, 'Projects Updated failed')
    end
  end

  private

  def find_project_user
    @project_user ||= current_user.project_users.find(params[:id]) if params[:id]
  end

  def project_user_params
    params.fetch(:project_user, {}).permit(:sort, :archived)
  end
end
