class AddDataToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :data, :hstore
  end
end
