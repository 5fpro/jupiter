class TodoToggleDoneContext < BaseContext
  before_perform :get_done_value
  after_perform :update_todo_last_recorded_at

  def initialize(todo)
    @todo = todo
  end

  def perform
    run_callbacks :perform do
      TodoCalculateContext.new(@todo).perform(done: @done)
    end
  end

  private

  def get_done_value
    @done = !@todo.done?
    true
  end

  def update_todo_last_recorded_at
    if @done
      @todo.last_recorded_at = Time.zone.now
      @todo.save
    end
  end
end
