class ChangeColumnOfTodoDoneDefault < ActiveRecord::Migration
  def up
    change_column :todos, :done, :boolean, default: nil
  end

  def down
    change_column :todos, :done, :boolean, default: false
  end
end
