class TodoDeleteContext < BaseContext
  before_perform :valid_unbind!

  def initialize(todo)
    @todo = todo
  end

  def perform
    run_callbacks :perform do
      @todo.destroy
    end
  end

  private

  def valid_unbind!
    return add_error(:todo_is_binding) if @todo.record_ids && @todo.record_ids.count > 0
    true
  end
end
