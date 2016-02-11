class AddColumnHstoreToProjectUers < ActiveRecord::Migration
  def change
    add_column :project_users, :data, :hstore
  end
end
