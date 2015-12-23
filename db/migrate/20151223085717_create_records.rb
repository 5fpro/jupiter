class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :user_id
      t.integer :project_id
      t.string  :record_type
      t.integer :minutes
      t.timestamps null: false
    end

    add_index :records, :user_id
    add_index :records, :project_id
    add_index :records, :record_type
  end
end
