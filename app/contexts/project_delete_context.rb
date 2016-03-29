class ProjectDeleteContext < BaseContext
  before_perform :validates_user!
  before_perform :check_todo

  def initialize(user, project)
    @user = user
    @project = project
  end

  def perform
    run_callbacks :perform do
      @project.destroy
    end
  end

  def validates_user!
    return add_error(:not_project_owner) unless @project.owner_id == @user.id
    true
  end

  def check_todo
    return add_error(:project_have_todo, "You can't delete project have todos") if @project.todos.first
    true
  end

end
