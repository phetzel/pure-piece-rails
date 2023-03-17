class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.string :stripe_id
      t.boolean :fulfilled

      t.timestamps
    end
  end
end
