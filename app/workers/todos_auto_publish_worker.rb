class TodosAutoPublishWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence backfill: true do
    # TODO: fix time zone, should 23:50
    daily(15).minute_of_hour(50)
  end

  def perform
    User.find_each do |user|
      unless user.todos_published?
        TodoPublishContext.delay(retry: false).perform(user.id, skip_user_update: true)
        user.update(todos_published: false)
      end
    end
  end

end
