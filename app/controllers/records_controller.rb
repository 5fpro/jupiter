class RecordsController < BaseController
  before_action :authenticate_user!

  before_action :find_project
  before_action :find_scoped
  before_action :find_record, only: [:edit, :update, :destroy]

  # GET /projects/:project_id/records
  # GET /records
  def index
    @q = Search::Record.where(nil).merge(@scoped).ransack(params[:q])
    @records = @q.result.page(params[:page]).per(30)
  end

  # GET /projects/:project_id/records/:id
  def show
    @record = @scoped.find(params[:id])
  end

  # GET /projects/:project_id/records/new
  def new
    @record = @scoped_with_user.new(params[:record])
  end

  # POST /projects/:project_id/records
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

  # GET /projects/:project_id/records/:id/edit
  def edit
  end

  # PUT /projects/:project_id/records/:id
  def update
    context = RecordUpdateContext.new(current_user, @record)
    if @record = context.perform(params)
      redirect_to params[:redirect_to] || project_record_path(@project, @record), flash: { success: "record update" }
    else
      edit
      flash.now[:error] = context.error_messages.join(", ")
      render :edit
    end
  end

  # DELETE /projects/:project_id/records/:id
  def destroy
    context = RecordDeleteContext.new(current_user, @record)
    if context.perform
      redirect_to params[:redirect_to] || project_records_path(@project), flash: { success: "record deleted" }
    else
      redirect_to :back, flash: { error: context.error_messages.join(", ") }
    end
  end

  private

  def find_project
    if params[:project_id]
      @project = current_user.projects.find(params[:project_id])
      @scoped = @project.records
    end
  end

  def find_scoped
    @scoped ||= current_user.records
    @scoped_with_user = current_user.records.merge(@scoped)
  end

  def find_record
    return unless params[:id]
    @record = @scoped_with_user.find(params[:id])
  end
end
