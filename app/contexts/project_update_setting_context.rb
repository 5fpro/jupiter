class ProjectUpdateSettingContext < BaseContext
  PERMITS = [:name, :price_of_hour, :owner_id, :monthly_limit_hours].freeze

  before_perform :validates_owner!
  before_perform :assign_value

  def initialize(user, project)
    @user = user
    @project = project
  end

  def perform(params)
    @params = permit_params(params[:project] || params, PERMITS)
    run_callbacks :perform do
      if @project.save
        @project
      else
        add_error(:update_project_fail, @project.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def validates_owner!
    return add_error(:user_is_not_owner) unless @project.owner_id == @user.id
    true
  end

  def assign_value
    @project.assign_attributes @params
  end
end
