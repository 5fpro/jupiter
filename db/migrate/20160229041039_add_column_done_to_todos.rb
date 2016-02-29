class AddColumnDoneToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :done, :boolean, default: false
    add_index :todos, :done
    add_index :todos, [:user_id, :done]
  end
end
