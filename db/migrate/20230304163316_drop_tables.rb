class DropTables < ActiveRecord::Migration[7.0]
  def up
    drop_table :payments
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
