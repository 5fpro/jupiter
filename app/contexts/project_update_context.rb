class ProjectUpdateContext < BaseContext
  PERMITS = [:description, :name, :price_of_hour, :owner_id, :hours_limit, :github_slack_users_mapping_json].freeze

  before_perform :validates_owner!
  before_perform :assign_value

  def initialize(user, project)
    @user = user
    @project = project
  end

  def perform(params)
    @params = permit_params(params[:project] || params, PERMITS)
    run_callbacks :perform do
      return @project if @project.save

      errors.add(:base, :data_update_fail, message: @project.errors.full_messages.join("\n"))
      return false
    end
  end

  private

  def validates_owner!
    return add_error(:not_project_owner) unless @project.owner?(@user)

    true
  end

  def assign_value
    @project.assign_attributes @params
  end
end
