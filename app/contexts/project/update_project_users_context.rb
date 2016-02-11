class Project::UpdateProjectUsersContext < BaseContext
  PERMITS = [{ project_users_attributes: [:slack_user, :id] }].freeze

  before_perform :assign_attrs

  def initialize(project, params)
    @project = project
    @params = permit_params(params, PERMITS)
  end

  def perform
    run_callbacks :perform do
      return add_error(:data_update_fail, @project.errors.full_messages.join("\n")) unless @project.save
      true
    end
  end

  private

  def assign_attrs
    @project.attributes = @params
  end

end
