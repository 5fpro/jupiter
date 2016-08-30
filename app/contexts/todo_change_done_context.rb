class TodoChangeDoneContext < BaseContext
  after_perform :update_todo_last_recorded_at

  def initialize(todo, done)
    @todo = todo
    @done = done
    @was_done = @todo.done?
  end

  def perform
    run_callbacks :perform do
      TodoCalculateContext.new(@todo).perform(done: @done)
    end
  end

  private

  def update_todo_last_recorded_at
    if !@was_done && @todo.done?
      @todo.last_recorded_at = Time.zone.now
      @todo.save
    end
  end
end
