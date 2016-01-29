class ProjectsController < BaseController
  before_action :authenticate_user!
  before_action :find_owned_project, only: [:setting, :update_setting]
  before_action :find_project

  def index
    @projects = current_user.projects
    @my_records = current_user.records
  end

  def show
  end

  def new
    @project ||= current_user.projects.new
  end

  def create
    context = UserCreateProjectContext.new(current_user, params)
    if @project = context.perform
      redirect_to project_path(@project), flash: { success: "project created" }
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
      update_fail(context.error_messages)
    end
  end

  def setting
  end

  def update_setting
    context = ProjectUpdateSettingContext.new(current_user, @project)
    if context.perform(params)
      redirect_to params[:redirect_to] || project_path(@project), flash: { success: "project updated" }
    else
      update_setting_fail(context.error_messages)
    end
  end

  private

  def find_project
    @project ||= current_user.projects.find(params[:id]) if params[:id]
  end

  def find_owned_project
    @project = current_user.owned_projects.find(params[:id])
  end

  def update_setting_fail(error_messages = nil)
    setting
    flash.now[:error] = error_messages if error_messages
    render :setting
  end

  def update_fail(error_messages = nil)
    edit
    flash.now[:error] = error_messages if error_messages
    render :edit
  end
end
