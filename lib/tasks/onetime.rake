namespace :onetime do

  task convert_todo_done_to_status: :environment do
    Todo.where(done: nil).map { |t| t.update_attributes(status: "pending") }
    Todo.where(done: false).map { |t| t.update_attributes(status: "doing") }
    Todo.where(done: true).map { |t| t.update_attributes(status: "finished") }
  end
end
