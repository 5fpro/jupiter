class TodoUpdateContext < BaseContext
  PERMITS = TodoCreateContext::PERMITS
  before_perform :validates_project!, if: :project_id?
  before_perform :validates_desc!
  before_perform :assign_value

  def initialize(todo, params)
    @todo = todo
    @params = permit_params(params[:todo] || params, PERMITS)
  end

  def perform
    run_callbacks :perform do
      return @todo if @todo.save
      add_error(:data_create_fail, @todo.errors.full_messages.join("\n"))
    end
  end

  private

  def project_id?
    @params[:project_id].present?
  end

  def validates_project!
    return add_error(:user_is_not_in_project) unless @todo.user.projects.find_by_id(@params[:project_id])
    true
  end

  def validates_desc!
    return add_error(:params_required) unless @params[:desc].present?
    true
  end

  def assign_value
    @todo.assign_attributes @params
  end
end
