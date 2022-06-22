class AddColumnDataToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :data, :hstore
  end
end
