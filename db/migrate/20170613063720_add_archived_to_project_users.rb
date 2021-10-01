class AddArchivedToProjectUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :project_users, :archived, :boolean, default: false
  end
end
