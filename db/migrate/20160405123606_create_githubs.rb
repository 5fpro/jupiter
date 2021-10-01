class CreateGithubs < ActiveRecord::Migration[5.2]
  def change
    create_table :githubs do |t|
      t.integer :project_id
      t.string :webhook_token
      t.hstore :data
      t.timestamps null: false
    end

    add_index :githubs, :webhook_token
  end
end
