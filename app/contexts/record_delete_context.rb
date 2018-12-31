class RecordDeleteContext < BaseContext
  before_perform :validates_user!
  after_perform :calculate_todo, if: :record_has_todo?
  after_perform :change_todo_status_if_no_records, if: :record_has_todo?

  def initialize(user, record)
    @user = user
    @record = record
    @todo = @record.todo
  end

  def perform
    run_callbacks :perform do
      @record.destroy
    end
  end

  private

  def record_has_todo?
    @todo
  end

  def validates_user!
    return add_error(:not_project_owner) unless @record.user_id == @user.id

    true
  end

  def calculate_todo
    TodoCalculateContext.new(@todo).perform
  end

  def change_todo_status_if_no_records
    TodoChangeStatusContext.new(@todo, 'doing').perform if @todo.finished? && @todo.records.count == 0
  end
end
