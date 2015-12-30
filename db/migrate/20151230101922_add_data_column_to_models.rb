class AddDataColumnToModels < ActiveRecord::Migration
  def change
    add_column :comments, :data, :hstore
    add_column :records, :data, :hstore
  end
end
