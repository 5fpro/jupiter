module ContextHelper
  def change_todo_status(todo, status)
    case status
    when "done"
      @done = "true"
    when "processing"
      @done = "false"
    when "not_done"
      @done = "nil"
    end
    TodoCalculateContext.new(todo).perform(done: @done)
  end
end
