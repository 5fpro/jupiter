class Project::HoursLimitCheckContext < BaseContext
  before_perform :has_value
  before_perform :approached_limit
  before_perform :make_changes
  after_perform :notify_to_slack

  THRESHOLD = 0.8

  class << self
    def perform(project_id)
      self.new(Project.find(project_id)).perform
    end
  end

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
    return false unless @project.hours_limit > 0
  end

  def approached_limit
    @approached = @project.hours_limit.hours.to_f * THRESHOLD < @project.records.this_month.total_time
    @project.approached_hours_limit = @approached
  end

  def make_changes
    @changes = @project.changes
  end

  def notify_to_slack
    if @approached && @changes["data"].try(:last).try(:[], "approached_hours_limit")
      Notify::TriggerContext.new(@project, :approach_hours_limit).perform(project: @project)
    end
  end
end
