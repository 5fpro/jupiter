class ProjectsController < BaseController
  before_action :authenticate_user!
  before_action :find_owned_project, only: [:edit, :update, :archive, :dearchive]
  before_action :find_project, except: [:edit_collection]

  def index
    @projects = current_user.projects.is_not_archived
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
    @project_users = current_user.project_users.sorted
  end

  def destroy
    context = ProjectDeleteContext.new(current_user, @project)
    if context.perform
      redirect_as_success(projects_path, "project deleted")
    else
      redirect_to :back, flash: { error: context.error_messages.join(", ") }
    end
  end

  def archived
    @projects = current_user.projects.is_archived
  end

  def archive
    @project.archived = true
    @project.save
    redirect_as_success(edit_projects_path, "project archived")
  end

  def dearchive
    @project.archived = false
    @project.save
    redirect_as_success(archived_projects_path, "project dearchived")
  end

  private

  def find_project
    @project ||= current_user.projects.find(params[:id]) if params[:id]
  end

  def find_owned_project
    @project = current_user.owned_projects.find(params[:id])
  end
end
