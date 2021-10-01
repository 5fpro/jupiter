class AddStatusToTodos < ActiveRecord::Migration[5.2]
  def change
    add_column :todos, :status, :integer
    add_index :todos, :status
  end
end
