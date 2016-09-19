class TodoCalculateContext < BaseContext
  before_perform :calculate_total_time
  before_perform :calculate_last_recorded_time
  before_perform :change_status

  def initialize(todo)
    @todo = todo
  end

  def perform(status: nil)
    @status = status
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

  def change_status
    TodoChangeStatusContext.new(@todo, @status).perform if @status
  end
end
