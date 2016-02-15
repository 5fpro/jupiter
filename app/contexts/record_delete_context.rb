class RecordDeleteContext < BaseContext
  before_perform :validates_user!

  def initialize(user, record)
    @user = user
    @record = record
  end

  def perform
    run_callbacks :perform do
      @record.destroy
    end
  end

  private

  def validates_user!
    return add_error(:not_project_owner) unless @record.user_id == @user.id
    true
  end
end
