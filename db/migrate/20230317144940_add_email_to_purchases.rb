class AddEmailToPurchases < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :email, :string
  end
end
