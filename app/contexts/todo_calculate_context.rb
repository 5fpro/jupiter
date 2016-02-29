class TodoCalculateContext < BaseContext
  before_perform :calculate_total_time
  before_perform :calculate_last_recorded_time
  before_perform :set_done

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
    @todo.done = @done if @done != nil
    @todo.done = false if !@todo.last_recorded_at
    true
  end
end
