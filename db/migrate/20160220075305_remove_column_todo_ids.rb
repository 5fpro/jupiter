class RemoveColumnTodoIds < ActiveRecord::Migration[5.2]
  def change
    remove_column :todos, :record_ids
  end
end
