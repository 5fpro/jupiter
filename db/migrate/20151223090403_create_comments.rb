class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :item_id
      t.string  :item_type
      t.timestamps null: false
    end

    add_index :comments, :user_id
    add_index :comments, [:item_id, :item_type]
  end
end
