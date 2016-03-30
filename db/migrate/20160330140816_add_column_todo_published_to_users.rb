class AddColumnTodoPublishedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :todos_published, :boolean, default: false
    add_index :users, :todos_published
  end
end
