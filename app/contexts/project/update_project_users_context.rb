class Project::UpdateProjectUsersContext < BaseContext
  PERMITS = [{ project_users_attributes: [:slack_user, :id, :wage] }].freeze

  before_perform :assign_attrs

  def initialize(project, params)
    @project = project
    @params = permit_params(params, PERMITS)
  end

  def perform
    run_callbacks :perform do
      unless @project.save
        errors.add(:base, :data_update_fail, message: @project.errors.full_messages.join("\n"))
        return false
      end
      true
    end
  end

  private

  def assign_attrs
    @project.attributes = @params
  end

end
