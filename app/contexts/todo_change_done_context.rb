class TodoChangeDoneContext < BaseContext
  after_perform :update_todo_last_recorded_at

  def initialize(todo, status)
    @todo = todo
    @status = status
    @was_done = @todo.finished?
  end

  def perform
    run_callbacks :perform do
      TodoCalculateContext.new(@todo).perform(status: @status)
    end
  end

  private

  def update_todo_last_recorded_at
    if !@was_done && @todo.finished?
      @todo.last_recorded_at = Time.zone.now
      @todo.save
    end
  end
end
