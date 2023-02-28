class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :amount_cents
      t.integer :payment_method
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
