class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :email
      t.boolean :subscribed, :default => true
      t.boolean :enabled, :default => true

      t.timestamps
    end
  end
end
