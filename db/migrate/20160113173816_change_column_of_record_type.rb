class ChangeColumnOfRecordType < ActiveRecord::Migration
  def change
    remove_index :records, :record_type
    remove_column :records, :record_type
    add_column :records, :record_type, :integer, default: nil
    add_index :records, [:project_id, :record_type]
  end
end
