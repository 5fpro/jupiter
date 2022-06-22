class RefactorIndexToModels < ActiveRecord::Migration[5.2]
  def change
    add_index :records, [:user_id, :project_id]
    remove_index :projects, :name
  end
end
