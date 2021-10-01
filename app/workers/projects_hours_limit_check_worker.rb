class ProjectsHoursLimitCheckWorker
  include Sidekiq::Worker

  def perform
    Project.find_each do |project|
      Project::HoursLimitCheckJob.perform_later(project.id)
    end
  end
end
