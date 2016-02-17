class AddColumnTodoIdToRecords < ActiveRecord::Migration
  def change
    add_column :records, :todo_id, :integer
    add_index :records, :todo_id
  end
end
