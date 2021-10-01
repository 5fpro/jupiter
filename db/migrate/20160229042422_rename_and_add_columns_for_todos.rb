class RenameAndAddColumnsForTodos < ActiveRecord::Migration[5.2]
  def change
    remove_index :todos, :date
    rename_column :todos, :date, :last_recorded_on
    add_column :todos, :last_recorded_at, :datetime
    add_index :todos, :last_recorded_on
  end
end
