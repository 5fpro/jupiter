class AddColumnTodoIdToRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :todo_id, :integer
    add_index :records, :todo_id
  end
end
