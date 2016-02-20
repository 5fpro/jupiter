class RemoveColumnTodoIds < ActiveRecord::Migration
  def change
    remove_column :todos, :record_ids
  end
end
