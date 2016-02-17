class TodoCreateContext < BaseContext
  PERMITS = [:project_id, :desc].freeze
  before_perform :validates_project!
  before_perform :validates_desc!
  before_perform :build_todo

  def initialize(user, params)
    @user = user
    @params = permit_params(params[:todo] || params, PERMITS)
  end

  def perform
    run_callbacks :perform do
      return @todo if @todo.save
      add_error(:data_create_fail, @todo.errors.full_messages.join("\n"))
    end
  end

  private

  def validates_project!
    return add_error(:user_is_not_in_project) unless @user.projects.find_by_id(@params[:project_id])
    true
  end

  def validates_desc!
    return add_error(:params_required) unless @params[:desc].present?
    true
  end

  def build_todo
    @todo = @user.todos.new(@params)
  end
end