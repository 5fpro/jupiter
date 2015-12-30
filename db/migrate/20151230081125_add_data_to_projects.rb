class AddDataToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :data, :hstore
  end
end
