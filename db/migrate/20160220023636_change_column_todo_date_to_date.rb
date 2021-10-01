class ChangeColumnTodoDateToDate < ActiveRecord::Migration[5.2]
  def change
    change_column :todos, :date, :date
  end
end
