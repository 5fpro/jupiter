namespace :dev do

  desc "Rebuild from schema.rb"
  task build: ["tmp:clear", "log:clear", "db:drop", "db:create", "db:schema:load", "dev:fake"]

  desc "Rebuild from migrations"
  task rebuild: ["tmp:clear", "log:clear", "db:drop", "db:create", "db:migrate", "dev:fake"]

  desc "generate fake data for development"
  task fake: :environment do
    email = "admin@5fpro.com"
    User.find_by(email: email) || FactoryGirl.create(:user, email: email, password: "12341234", admin: true)
  end

end

namespace :onetime do
  task convert_todo_done_to_status: :environment do
    Todo.where(done: nil).map { |t| t.update_attributes(status: 1) }
    Todo.where(done: false).map { |t| t.update_attributes(status: 2) }
    Todo.where(done: true).map { |t| t.update_attributes(status: 3) }
  end
end
