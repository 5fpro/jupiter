class RecordsController < BaseController
  before_action :authenticate_user!

  before_filter :project
  before_filter :record

  def index
    @records = project.records
  end

  def show
  end

  def new
    @record = Record.new(params[:record])
  end

  def create
    context = RecordCreateContext.new(current_user, @project)
    if @record = context.perform(params)
      redirect_to params[:redirect_to] || project_record_path(project, @record), flash: { success: "record created" }
    else
      new()
      flash.now[:error] = context.error_messages.join(", ")
      render :new
    end
  end

  def edit

  end

  def update
    if record.update_attributes(record_params)
      redirect_to params[:redirect_to] || project_record_path(project, record), flash: { success: "record updated" }
    else
      edit()
      flash.now[:error] = record.errors.full_messages
      render :edit
    end
  end

  def destroy
    if record.destroy
      redirect_to params[:redirect_to] || project_records_path, flash: { success: "record deleted" }
    else
      redirect_to :back, flash: { error: record.errors.full_messages }
    end
  end

  def histories

  end

  private

  def project
    @project = Project.find(params[:project_id])
  end

  def record
    @record ||= @project.records.find(params[:id]) if params[:id]
    @record
  end

  def record_params
    params.fetch(:record, {}).permit(:user_id, :project_id, :record_type, :minutes, :tmp)
  end
end
