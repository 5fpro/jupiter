class RecordCreateContext < BaseContext
  PERMITS = [:record_type, :minutes, :note, :todo_id, :todo_done].freeze
  attr_accessor :project, :user, :record

  before_perform :init_params
  before_perform :validates_user_in_project!
  before_perform :build_record
  before_perform :copy_note_from_todo_desc
  after_perform :notify_slack_channels
  after_perform :create_todo_if_not_choose
  after_perform :calculate_todo

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
        return add_error(:data_create_fail, @record.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def init_params
    @params = permit_params(@params, PERMITS)
    @todo_done = false?(@params.delete(:todo_done)) ? "false" : "true"
    true
  end

  def validates_user_in_project!
    return add_error(:user_is_not_in_project) unless @project.has_user?(@user)
    true
  end

  def build_record
    @record = @project.records.build(@params)
    @record.user = @user
  end

  def notify_slack_channels
    Notify::TriggerContext.new(@project, :record_created).perform(record: @record)
  end

  def copy_note_from_todo_desc
    @record.note = "#{@record.todo.desc}\n#{record.note}" if @record.todo
  end

  def create_todo_if_not_choose
    TodoCreateByRecordContext.new(@record).perform unless @record.todo
  end

  def calculate_todo
    TodoCalculateContext.new(@record.todo).perform(done: @todo_done) if @record.todo
  end

end
