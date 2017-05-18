class ProjectsController < BaseController
  before_action :authenticate_user!
  before_action :find_owned_project, only: [:edit, :update, :click_archive]
  before_action :find_project, except: [:edit_collection, :archived, :click_archive]

  def index
    @projects = current_user.projects.archived?(false)
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
      redirect_as_success(project_path(@project), "project created")
    else
      render_as_fail(:new, context.error_messages)
    end
  end

  def edit
  end

  def update
    context = ProjectUpdateContext.new(current_user, @project)
    if context.perform(params)
      redirect_as_success(project_path(@project), "project updated")
    else
      render_as_fail(:edit, context.error_messages)
    end
  end

  def edit_collection
    @project_users = ProjectUser.project_archived(current_user.project_users.sorted, false)
  end

  def click_archive
    if @project.is_archived?
      @project.update_attribute(:is_archived, false)
      redirect_to archived_projects_path
    else
      @project.update_attribute(:is_archived, true)
      redirect_to edit_projects_path
    end
  end

  def archived
    @project_users = ProjectUser.project_archived(current_user.project_users.sorted, true)
  end

  def destroy
    context = ProjectDeleteContext.new(current_user, @project)
    if context.perform
      redirect_as_success(projects_path, "project deleted")
    else
      redirect_to :back, flash: { error: context.error_messages.join(", ") }
    end
  end

  private

  def find_project
    @project ||= current_user.projects.find(params[:id]) if params[:id]
  end

  def find_owned_project
    @project = current_user.owned_projects.find(params[:id])
  end
end
