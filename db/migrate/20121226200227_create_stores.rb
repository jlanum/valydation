class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name, :null => false
      t.string :url, :null => false
      t.timestamps
    end

    add_column :sales, :store_id, :integer

    add_index :stores, :name
    add_index :stores, :url
    add_index :sales, :store_id

    Sale.all.each do |sale|
      sale.set_store
      sale.save!
    end
  end
end
