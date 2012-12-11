class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :user_id, :null => false
      t.string :store_name, :limit => 128, :null => false
      t.text :store_url
      t.string :brand, :limit => 128, :null => false
      t.decimal :orig_price, :precision => 8, :scale => 2, :null => false
      t.decimal :sale_price, :precision => 8, :scale => 2, :null => false
      t.string :product, :limit => 128, :null => false
      t.integer :category_id, :null => false
      t.timestamps
    end
  end
end
