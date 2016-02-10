class Project::MonthlyLimitHoursCheckContext < BaseContext
  before_perform :has_value
  before_perform :approached_limit
  before_perform :make_changes
  after_perform :notify_to_slack

  THRESHOLD = 0.8

  def initialize(project)
    @project = project
  end

  def perform
    run_callbacks :perform do
      @project.save!
    end
  end

  private

  def has_value
    return false unless @project.monthly_limit_hours > 0
  end

  def approached_limit
    @approached = @project.monthly_limit_hours.hours.to_f * THRESHOLD < @project.records.this_month.total_time
    @project.approached_monthly_limit_hours = @approached
  end

  def make_changes
    @changes = @project.changes
  end

  def notify_to_slack
    if @approached && @changes["data"].try(:last).try(:[], "approached_monthly_limit_hours")
      Notify::TriggerContext.new(@project, :monthly_limit_hours_approach).perform(project: @project)
    end
  end
end
