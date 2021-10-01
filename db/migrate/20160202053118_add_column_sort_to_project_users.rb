class AddColumnSortToProjectUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :project_users, :sort, :integer
    add_index :project_users, [:user_id, :sort]
  end
end
