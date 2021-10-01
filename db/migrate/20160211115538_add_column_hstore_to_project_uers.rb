class AddColumnHstoreToProjectUers < ActiveRecord::Migration[5.2]
  def change
    add_column :project_users, :data, :hstore
  end
end
