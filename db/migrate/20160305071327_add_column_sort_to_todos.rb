class AddColumnSortToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :sort, :integer
    add_index :todos, [:user_id, :done, :sort]
    if Rails.env.production?
      User.find_each do |user|
        user.todos.pending.project_sorted.each do |todo|
          todo.insert_at(1)
          todo.move_to_bottom
        end
      end
    end
  end
end
