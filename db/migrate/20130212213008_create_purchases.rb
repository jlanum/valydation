class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id, :null => false
      t.integer :sale_id, :null => false
      t.string :status, :null => false
      t.string :external_id
      t.string :external_status
      t.text :external_message

      t.timestamps
    end
  end
end
