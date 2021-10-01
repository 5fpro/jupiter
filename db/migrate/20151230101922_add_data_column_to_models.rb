class AddDataColumnToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :data, :hstore
    add_column :records, :data, :hstore
  end
end
