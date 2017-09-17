class TodosAutoPublishWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence backfill: true do
    # TODO: fix time zone, should 23:50
    daily.hour_of_day(15).minute_of_hour(50)
  end

  def perform
    User.find_each do |user|
      if user.todos_published? || user.records.today.empty?
        user.update(todos_published: false)
      else
        TodosAutoPublishJob.perform_later(user.id, skip_user_update: true)
      end
    end
  end

end
