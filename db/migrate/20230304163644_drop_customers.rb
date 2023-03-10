class DropCustomers < ActiveRecord::Migration[7.0]
  def up
    drop_table :customers
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
