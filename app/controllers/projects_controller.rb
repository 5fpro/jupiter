class ProjectsController < BaseController
  before_action :authenticate_user!
  before_action :project

  def index
    @projects = current_user.projects
    @my_records = current_user.records
  end

  def show
  end

  def new
  end

  def create
    context = UserCreateProjectContext.new(current_user, params)
    if project = context.perform
      redirect_to project_path(project), flash: { success: "project created" }
    else
      redirect_to projects_path, flash: { error: context.error_messages.join(",") }
    end
  end

  def edit
  end

  def update
    if project.update_attributes(project_params)
      redirect_to params[:redirect_to] || project_path(project), flash: { success: "project updated" }
    else
      edit
      flash.now[:error] = project.errors.full_messages
      render :edit
    end
  end

  private

  def project
    @project ||= params[:id] ? Project.find(params[:id]) : Project.new(project_params)
  end

  def project_params
    params.fetch(:project, {}).permit(:price_of_hour, :name, :owner_id, :tmp)
  end
end
