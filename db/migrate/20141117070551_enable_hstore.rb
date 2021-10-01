class EnableHstore < ActiveRecord::Migration[5.2]
  def up
    execute 'CREATE EXTENSION hstore'
  end

  def down
    execute 'DROP EXTENSION hstore'
  end
end
