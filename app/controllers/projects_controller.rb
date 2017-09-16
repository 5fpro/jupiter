class ProjectsController < BaseController
  before_action :authenticate_user!
  before_action :find_owned_project, only: [:edit, :update]
  before_action :find_project, except: [:edit_collection]

  def index
    @projects = UserProjectsQuery.new(current_user).query(archived: false)
    @my_records = current_user.records
  end

  def show
  end

  def settlement
    @time = params[:date]
    @time = Time.now if @time.blank?
    @settlement = Project::GetSettlementContext.new(@project, @time).perform
  end

  def my_settlement
    @time = params[:date]
    @time = Time.now if @time.blank?
    @settlements_data = User::GetSettlementContext.new(current_user, @time).perform
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
    @project_users = current_user.project_users.unarchived.sorted.includes(:project)
  end

  def destroy
    context = ProjectDeleteContext.new(current_user, @project)
    if context.perform
      redirect_as_success(projects_path, "project deleted")
    else
      redirect_to :back, flash: { error: context.error_messages.join(", ") }
    end
  end

  def edit_archived
    @project_users = current_user.project_users.archived.sorted.includes(:project)
  end

  private

  def find_project
    @project ||= current_user.projects.find(params[:id]) if params[:id]
  end

  def find_owned_project
    @project = current_user.owned_projects.find(params[:id])
  end
end
