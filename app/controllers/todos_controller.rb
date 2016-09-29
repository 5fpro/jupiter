class TodosController < BaseController
  before_action :authenticate_user!
  before_action :find_todos
  before_action :find_todo, only: [:edit, :update, :destroy, :change_done]

  def index
    @done_todos = @todos.today_done.order(updated_at: :desc)
    @not_done_todos = not_done_todos
    @processing_todos = processing_todos
  end

  def new
    @todo = @todos.new(project_id: params[:project_id])
  end

  def edit
  end

  def create
    context = TodoCreateContext.new(current_user, params[:todo])
    if @todo = context.perform
      @not_done_todos = not_done_todos
      # render js
    else
      @error_messages = context.error_messages
    end
  end

  def update
    context = TodoUpdateContext.new(@todo, params[:todo])
    if context.perform
      @processing_todos = processing_todos
      # render js
    else
      @error_messages = context.error_messages
    end
  end

  def destroy
    context = TodoDeleteContext.new(@todo)
    if context.perform
      @processing_todos = processing_todos
      @not_done_todos = not_done_todos
      # render js
    else
      @error_messages = context.error_messages
    end
  end

  def change_done
    context = TodoChangeDoneContext.new(@todo, params[:done])
    context.perform
    @not_done_todos = not_done_todos
    @done_todos = @todos.today_done.order(updated_at: :desc)
    @processing_todos = processing_todos
  end

  def publish
    TodoPublishContext.new(current_user).perform
    redirect_to :back, flash: { success: "已發佈" }
  end

  private

  def find_todos
    @todos = current_user.todos.sorted.includes(:project, :records)
  end

  def not_done_todos
    @todos.not_done.order(updated_at: :desc)
  end

  def processing_todos
    @todos.processing
  end

  def find_todo
    @todo = @todos.find(params[:id])
  end
end
