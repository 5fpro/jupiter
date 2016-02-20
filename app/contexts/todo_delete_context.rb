class TodoDeleteContext < BaseContext
  before_perform :validates_done_yet

  def initialize(todo)
    @todo = todo
  end

  def perform
    run_callbacks :perform do
      @todo.destroy
    end
  end

  private

  def validates_done_yet
    return add_error(:data_delete_fail, "Todo ##{@todo.id} has done") if @todo.done?
    true
  end
end
