class ProjectsController < BaseController
  before_filter :project

  def index
    @projects = Project.all
  end

  def show

  end

  def new
    
  end

  def create
    if project.save
      redirect_to params[:redirect_to] || project_path(project), flash: { success: "project created" }
    else
      new()
      flash.now[:error] = project.errors.full_messages
      render :new
    end
  end

  def edit

  end

  def update
    if project.update_attributes(project_params)
      redirect_to params[:redirect_to] || project_path(project), flash: { success: "project updated" }
    else
      edit()
      flash.now[:error] = project.errors.full_messages
      render :edit
    end
  end

  private

  def project
    @project ||= params[:id] ? Project.find(params[:id]) : Project.new(project_params)
  end

  def project_params
    params.fetch(:projects, {}).permit(:price_of_hour, :name, :owner_id, :tmp)
  end
end
