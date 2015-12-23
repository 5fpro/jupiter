class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :price_of_hour
      t.string  :name
      t.integer :owner_id 
      t.timestamps null: false
    end

    add_index :projects, :owner_id
    add_index :projects, :name
  end
end
