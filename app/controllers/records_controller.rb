class RecordsController < BaseController
  before_action :authenticate_user!

  before_action :find_project
  before_action :find_record, only: [ :edit, :update, :destroy]

  def index
    @q = Search::Record.where(project_id: @project.id).order("id DESC").ransack(params[:q])
    @records = @q.result.page(params[:page]).per(30)
  end

  def show
    @record = @project.records.find(params[:id])
  end

  def new
    @record = current_user.records.new(params[:record])
  end

  def create
    context = RecordCreateContext.new(current_user, @project)
    if @record = context.perform(params)
      redirect_to params[:redirect_to] || project_record_path(@project, @record), flash: { success: "record created" }
    else
      new
      flash.now[:error] = context.error_messages.join(", ")
      render :new
    end
  end

  def edit
  end

  def update
    context = RecordUpdateContext.new(current_user, @record)
    if @record = context.perform(params)
      redirect_to project_record_path(@project, @record), flash: { success: "record update" }
    else
      edit
      flash.now[:error] = context.error_messages.join(", ")
      render :edit
    end
  end

  def destroy
    context = RecordDeleteContext.new(current_user, @record)
    if context.perform
      redirect_to project_records_path(@project), flash: { success: "record deleted" }
    else
      redirect_to :back, flash: { error: context.error_messages.join(", ") }
    end
  end

  private

  def find_project
    @project ||= current_user.projects.find(params[:project_id])
    @project
  end

  def find_record
    return unless params[:id]
    @record = current_user.records.where(project_id: @project.id).find(params[:id])
  end
end
