class ProjectsHoursLimitCheckWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence backfill: true do
    # TODO: fix time zone
    daily.hour_of_day(9)
  end

  def perform
    Project.find_each do |project|
      Project::HoursLimitCheckContext.delay(retry: false).perform(project.id)
    end
  end
end
