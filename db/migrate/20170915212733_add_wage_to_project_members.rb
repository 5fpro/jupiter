class AddWageToProjectMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :project_users, :wage, :integer
  end
end
