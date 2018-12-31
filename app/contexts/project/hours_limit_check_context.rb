class Project::HoursLimitCheckContext < BaseContext
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
    throw :abort unless @project.hours_limit > 0
  end

  def approached_limit
    @approached = @project.hours_limit.hours.to_f * THRESHOLD < @project.records.this_month.total_time
    @approached_hours_limit_was = @project.approached_hours_limit
    @project.approached_hours_limit = @approached
    throw :abort unless @approached
  end

  def make_changes
    @changed = @approached_hours_limit_was != @approached
    throw :abort unless @changed
  end

  def notify_to_slack
    if @approached && @changed
      Notify::TriggerContext.new(@project, :approach_hours_limit).perform(project: @project)
    end
  end
end
