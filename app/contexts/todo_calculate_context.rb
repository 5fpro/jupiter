class TodoCalculateContext < BaseContext
  before_perform :calculate_total_time
  before_perform :calculate_date
  before_perform :set_done

  def initialize(todo)
    @todo = todo
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

  def calculate_total_time
    @todo.total_time = @todo.records.select(:minutes).map(&:total_time).map(&:to_i).inject(&:+)
  end

  def calculate_date
    @todo.date = @todo.records.order(id: :asc).first.try(:created_at).try(:to_date)
    true
  end

  def set_done
    @todo.done = @todo.date.present?
    true
  end
end
