class ProjectDeleteContext < BaseContext
  before_perform :validates_user!
  before_perform :check_todo_empty

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

  def check_todo_empty
    return add_error(:data_delete_fail) if @project.todos.present?
    true
  end

end
