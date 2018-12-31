class Project::HoursLimitCheckJob < ApplicationJob
  def perform(project_id)
    Project::HoursLimitCheckContext.new(Project.find(project_id)).perform
  end
end
