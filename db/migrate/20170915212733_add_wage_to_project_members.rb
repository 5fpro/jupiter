class AddWageToProjectMembers < ActiveRecord::Migration
  def change
    add_column :project_users, :wage, :integer
  end
end
