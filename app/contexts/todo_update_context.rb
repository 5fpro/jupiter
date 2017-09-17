class TodoUpdateContext < BaseContext
  PERMITS = TodoCreateContext::PERMITS + [:sort]
  before_perform :validates_project!, if: :project_id?
  before_perform :sorting
  before_perform :assign_value

  def initialize(todo, params)
    @todo = todo
    @params = permit_params(params[:todo] || params, PERMITS)
  end

  def perform
    run_callbacks :perform do
      unless @todo.save
        errors.add(:base, :data_create_fail, message: @todo.errors.full_messages.join("\n"))
        return false
      end
      true
    end
  end

  private

  def project_id?
    @params[:project_id].present?
  end

  def validates_project!
    add_error(:user_is_not_in_project) unless @todo.user.projects.where(id: @params[:project_id]).count > 0
  end

  def sorting
    if @params.key?(:sort)
      @todo.sort = @params.delete :sort
    end
  end

  def assign_value
    @todo.assign_attributes @params
  end
end
