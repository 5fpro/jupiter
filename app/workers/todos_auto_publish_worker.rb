class TodosAutoPublishWorker
  include Sidekiq::Worker

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
