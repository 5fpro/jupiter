class TodosController < BaseController
  before_action :authenticate_user!
  before_action :find_todos
  before_action :find_todo, only: [:edit, :update, :destroy, :change_status]

  def index
<<<<<<< 148c8449f252b2bc5f13b5783ae45080fb051cba
    @done_todos = @todos.today_done.order(updated_at: :desc)
    @not_done_todos = not_done_todos
    @processing_todos = processing_todos
=======
    @finished_todos = @todos.today_done
    @pending_todos = pending_todos
    @doing_todos = doing_todos
>>>>>>> aasm 狀態機功能實作  done -> status
  end

  def new
    @todo = @todos.new(project_id: params[:project_id])
  end

  def edit
  end

  def create
    context = TodoCreateContext.new(current_user, params[:todo])
    if @todo = context.perform
      @pending_todos = pending_todos
      # render js
    else
      @error_messages = context.error_messages
    end
  end

  def update
    context = TodoUpdateContext.new(@todo, params[:todo])
    if context.perform
      @doing_todos = doing_todos
      # render js
    else
      @error_messages = context.error_messages
    end
  end

  def destroy
    context = TodoDeleteContext.new(@todo)
    if context.perform
      @doing_todos = doing_todos
      @pending_todos = pending_todos
      # render js
    else
      @error_messages = context.error_messages
    end
  end

  def change_status
    context = TodoChangeDoneContext.new(@todo, params[:status])
    context.perform
    @pending_todos = pending_todos
    @finished_todos = @todos.today_done.order(updated_at: :desc)
    @doing_todos = doing_todos
  end

  def publish
    TodoPublishContext.new(current_user).perform
    redirect_to :back, flash: { success: "已發佈" }
  end

  private

  def find_todos
    @todos = current_user.todos.sorted.includes(:project, :records)
  end

<<<<<<< 148c8449f252b2bc5f13b5783ae45080fb051cba
  def not_done_todos
    @todos.not_done.order(updated_at: :desc)
=======
  def pending_todos
    @todos.pending
>>>>>>> aasm 狀態機功能實作  done -> status
  end

  def doing_todos
    @todos.doing
  end

  def find_todo
    @todo = @todos.find(params[:id])
  end
end
