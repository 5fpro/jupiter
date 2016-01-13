class RecordCreateContext < BaseContext
  PERMITS = [:record_type, :minutes, :note]
  attr_accessor :project, :user, :record

  before_perform :init_params
  before_perform :validates_user_in_project!
  before_perform :build_record

  def initialize(user, project)
    @user = user
    @project = project
  end

  def perform(params)
    @params = params[:record] || params
    run_callbacks :perform do
      if @record.save
        @record
      else
        return add_error(:data_not_created, @record.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def init_params
    @params = permit_params(@params, PERMITS)
  end

  def validates_user_in_project!
    return add_error(:user_is_not_in_project) unless @project.has_user?(@user)
    true
  end

  def build_record
    @record = @project.records.build(@params)
    @record.user = @user
  end
end
