class TodosController < BaseController
  before_action :authenticate_user!
  before_action :find_todos
  before_action :find_todo, only: [:edit, :update, :destroy, :clone]

  def index
    @done_todos = @todos.today_done
    @not_done_todos = not_done_todos
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
      # render js
    else
      @error_messages = context.error_messages
    end
  end

  def destroy
    context = TodoDeleteContext.new(@todo)
    if context.perform
      @not_done_todos = not_done_todos
      # render js
    else
      @error_messages = context.error_messages
    end
  end

  def clone
    context = TodoCloneContext.new(@todo)
    if context.perform
      @not_done_todos = not_done_todos
      # render js
    else
      @error_messages = context.error_messages
    end
  end

  private

  def find_todos
    @todos = current_user.todos.project_sorted.includes(:project, :records)
  end

  def not_done_todos
    @todos.not_done
  end

  def find_todo
    @todo = @todos.find(params[:id])
  end
end
