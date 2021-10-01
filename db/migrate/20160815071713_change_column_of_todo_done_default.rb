class ChangeColumnOfTodoDoneDefault < ActiveRecord::Migration[5.2]
  def up
    change_column :todos, :done, :boolean, default: nil
  end

  def down
    change_column :todos, :done, :boolean, default: false
  end
end
