class AddUnsubscribeHashToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :unsubscribe_hash, :string
    add_column :subscriptions, :string, :string
  end
end
