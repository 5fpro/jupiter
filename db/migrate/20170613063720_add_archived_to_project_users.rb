class AddArchivedToProjectUsers < ActiveRecord::Migration
  def change
    add_column :project_users, :archived, :boolean, default: false
  end
end
