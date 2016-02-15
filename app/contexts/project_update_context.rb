class ProjectUpdateContext < BaseContext
  PERMITS = [:description].freeze

  before_perform :validates_project_user!
  before_perform :assign_value

  def initialize(user, project)
    @user = user
    @project = project
  end

  def perform(params)
    @params = permit_params(params[:project] || params, PERMITS)
    run_callbacks :perform do
      return @project if @project.save
      add_error(:data_update_fail, @project.errors.full_messages.join("\n"))
    end
  end

  private

  def validates_project_user!
    return add_error(:user_is_not_in_project) unless @project.has_user?(@user)
    true
  end

  def assign_value
    @project.assign_attributes @params
  end
end
