class RemoveColumnTodoDone < ActiveRecord::Migration[5.2]
  def change
    remove_column :todos, :done
  end
end
