class CreateProjectUsers < ActiveRecord::Migration
  def change
    create_table :project_users do |t|
      t.integer :project_id
      t.integer :user_id
      t.timestamps null: false
    end

    add_index :project_users, :project_id
    add_index :project_users, :user_id
    add_index :project_users, [:project_id, :user_id]
  end
end
