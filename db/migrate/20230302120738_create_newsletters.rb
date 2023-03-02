class CreateNewsletters < ActiveRecord::Migration[7.0]
  def change
    create_table :newsletters do |t|
      t.string :subject, null: false
      t.string :message, null: false

      t.timestamps
    end
  end
end
