class CreateSlackChannels < ActiveRecord::Migration
  def change
    create_table :slack_channels do |t|
      t.integer :project_id
      t.boolean :disabled, default: false
      t.hstore :data
      t.timestamps null: false
    end
    add_index :slack_channels, :project_id
  end
end
