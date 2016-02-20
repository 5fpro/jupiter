class TodoUpdateContext < BaseContext
  PERMITS = TodoCreateContext::PERMITS
  before_perform :validates_project!, if: :project_id?
  before_perform :assign_value

  def initialize(todo, params)
    @todo = todo
    @params = permit_params(params[:todo] || params, PERMITS)
  end

  def perform
    run_callbacks :perform do
      return add_error(:data_create_fail, @todo.errors.full_messages.join("\n")) unless @todo.save
      true
    end
  end

  private

  def project_id?
    @params[:project_id].present?
  end

  def validates_project!
    return add_error(:user_is_not_in_project) unless @todo.user.projects.where(id: @params[:project_id]).count > 0
    true
  end

  def assign_value
    @todo.assign_attributes @params
  end
end
