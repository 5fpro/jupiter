class RecordsController < BaseController
  before_action :authenticate_user!, except: [:share]

  before_action :find_project, except: [:share]
  before_action :find_scoped, except: [:share]
  before_action :find_record, only: [:edit, :update, :destroy]

  # GET /projects/:project_id/records
  # GET /records
  def index
    @q = Search::Record.where(nil).merge(@scoped.order("id DESC")).ransack(params[:q])
    @records = @q.result.page(params[:page]).per(30)
    @total_time = @q.result.total_time
  end

  def share
    @project = Project.find(params[:project_id])
    @scoped = @project.records
    index
    respond_to do |f|
      f.html { render :share, layout: "public" }
      f.csv do
        data = @records.offset(0).limit(nil).to_csv
        send_data data, type: Mime::CSV, disposition: "attachment"
      end
    end
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
      respond_to do |f|
        f.html { redirect_as_success(project_record_path(@project, @record), "record created") }
        f.js { render }
      end
    else
      @error_messages = context.error_messages.join(", ")
      respond_to do |f|
        f.html { render_as_fail(:new, @error_messages) }
        f.js { render }
      end
    end
  end

  # GET /projects/:project_id/records/:id/edit
  def edit
  end

  # PUT /projects/:project_id/records/:id
  def update
    context = RecordUpdateContext.new(current_user, @record)
    if @record = context.perform(params)
      redirect_as_success(project_record_path(@project, @record), "record update")
    else
      render_as_fail(:edit, context.error_messages)
    end
  end

  # DELETE /projects/:project_id/records/:id
  def destroy
    context = RecordDeleteContext.new(current_user, @record)
    if context.perform
      redirect_as_success(project_records_path(@project), "record deleted")
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
