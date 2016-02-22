class TodoCloneContext < BaseContext
  before_perform :validates_todo_state
  before_perform :build_todo

  def initialize(todo)
    @todo = todo
  end

  def perform
    run_callbacks :perform do
      return add_error(:data_create_fail, @new_todo.errors.full_messages.join("\n")) unless @new_todo.save
      @new_todo
    end
  end

  private

  def validates_todo_state
    return add_error(:validates_fail, "todo state should be done") unless @todo.done?
    true
  end

  def build_todo
    @new_todo = Todo.new(todo_attrs)
  end

  def todo_attrs
    { original_id: @todo.id,
      project_id: @todo.project_id,
      user_id: @todo.user_id,
      desc: @todo.desc
    }
  end
end
