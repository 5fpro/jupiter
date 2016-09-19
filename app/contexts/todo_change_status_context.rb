class TodoChangeStatusContext < BaseContext
  before_perform :change_status
  after_perform :remove_sort
  after_perform :add_to_sort
  after_perform :update_todo_last_recorded_at

  def initialize(todo, status)
    @todo = todo
    @status = status.to_s
    @was_done = @todo.finished?
  end

  def perform
    run_callbacks :perform do
      if @todo.save
        true
      else
        add_error(:data_update_fail, @todo.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def change_status
    case @status
    when "finished"
      @todo.to_finished if @todo.last_recorded_at
    when "doing"
      @todo.to_doing
    when "pending"
      @todo.to_pending
    end
  end

  def remove_sort
    if !@todo.doing? && @todo.in_list?
      @todo.remove_from_list
    end
  end

  def add_to_sort
    if @todo.doing? && @todo.not_in_list?
      @todo.insert_at(1)
      @todo.move_to_bottom
    end
  end

  def update_todo_last_recorded_at
    if !@was_done && @todo.finished?
      @todo.update(last_recorded_at: Time.zone.now)
    end
  end
end
