class AddIsArchivedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :is_archived, :boolean, :default => false
  end
end
