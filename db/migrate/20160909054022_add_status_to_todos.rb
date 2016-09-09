class AddStatusToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :status, :integer
    add_index :todos, :status
  end
end
