class TodosAutoPublishJob < ApplicationJob
  def perform(user_id, opts = {})
    user = User.find(user_id)
    TodoPublishContext.new(user).perform(opts.symbolize_keys)
  end
end
