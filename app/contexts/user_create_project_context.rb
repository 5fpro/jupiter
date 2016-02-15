class UserCreateProjectContext < BaseContext
  PERMITS = [:name, :price_of_hour].freeze

  before_perform :build_project
  after_perform  :create_project_users

  def initialize(user, params)
    @user = user
    @params = permit_params(params[:project] || params, PERMITS)
  end

  def perform
    run_callbacks :perform do
      if @project.save
        @project
      else
        add_error(:data_create_fail, @project.errors.full_messages.join("\n"))
      end
    end
  end

  private

  def build_project
    @project = @user.owned_projects.new(@params)
  end

  def create_project_users
    Common::ProjectAddUserContext.new(@project, @user).perform
  end
end
