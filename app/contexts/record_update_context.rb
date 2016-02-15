class RecordUpdateContext < BaseContext
  PERMITS = [:minutes, :note, :record_type].freeze

  before_perform :validates_user!
  before_perform :assign_value

  def initialize(user, record)
    @user = user
    @record = record
  end

  def perform(params)
    @params = permit_params(params[:record] || params, PERMITS)
    run_callbacks :perform do
      if @record.save
        @record
      else
        add_error(:data_update_fail, @record.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def validates_user!
    return add_error(:not_project_owner) unless @record.user_id == @user.id
    true
  end

  def assign_value
    @record.assign_attributes @params
  end
end
