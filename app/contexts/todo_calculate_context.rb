class TodoCalculateContext < BaseContext
  before_perform :calculate_total_time
  before_perform :calculate_last_recorded_time
  before_perform :set_done
  after_perform :remove_sort
  after_perform :add_to_sort

  def initialize(todo)
    @todo = todo
  end

  def perform(done: nil)
    @done = done
    run_callbacks :perform do
      if @todo.save
        true
      else
        add_error(:data_update_fail, @todo.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def calculate_total_time
    @todo.total_time = @todo.records.select(:minutes).map(&:total_time).map(&:to_i).inject(&:+)
  end

  def calculate_last_recorded_time
    @todo.last_recorded_at = @todo.records.order(id: :desc).first.try(:created_at)
    true
  end

  def set_done
    if @done.present?
      @todo.done = true if @done == "true" && @todo.last_recorded_at
      @todo.done = nil if @done == "nil"
      @todo.done = false if @done == "false"
    else
      @todo.done = false unless @todo.last_recorded_at
    end
    true
  end

  def remove_sort
    if @todo.done != false && @todo.in_list?
      @todo.remove_from_list
    end
  end

  def add_to_sort
    if @todo.done == false && @todo.not_in_list?
      @todo.insert_at(1)
      @todo.move_to_bottom
    end
  end
end
