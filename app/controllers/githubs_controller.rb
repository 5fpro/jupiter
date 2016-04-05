class GithubsController < BaseController
  before_action :authenticate_user!
  before_action :find_owned_project
  before_action :find_github

  def index
    @githubs = @project.githubs
  end

  def new
    @github ||= @project.githubs.new
  end

  def create
    context = Github::BindContext.new(@project, params)
    if context.perform
      redirect_as_success(project_path(@project), "github binded")
    end
  end

  def destroy
    context = Github::UnbindContext.new(@github)
    if context.perform
      redirect_as_success(project_path(@project), "github unbind")
    end
  end

  private

  def find_owned_project
    @project = current_user.owned_projects.find(params[:project_id])
  end

  def find_github
    @github ||= params[:id] ? @project.githubs.find(params[:id]) : nil
  end
end
