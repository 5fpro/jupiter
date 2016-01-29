class ProjectsController < BaseController
  before_action :authenticate_user!
  before_action :find_project

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
    context = ProjectUpdateContext.new(current_user, @project)
    if context.perform(params)
      redirect_to params[:redirect_to] || project_path(@project), flash: { success: "project updated" }
    else
      update_fail
    end
  end

  private

  def find_project
    @project = current_user.projects.find(params[:id])
  end

  def update_fail
    edit
    flash.now[:error] = @project.errors.full_messages
    render :edit
  end
end
