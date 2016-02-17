class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer   :user_id
      t.integer   :project_id
      t.text      :desc
      t.text      :record_ids
      t.datetime  :date
      t.hstore    :data
      t.timestamps null: false
    end

    add_index :todos, [:user_id, :project_id]
    add_index :todos, [:user_id, :date]
    add_index :todos, [:project_id, :date]
    add_index :todos, :user_id
    add_index :todos, :project_id
    add_index :todos, :date
  end
end
