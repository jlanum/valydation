class RemoveSaleIdColFromPurchases < ActiveRecord::Migration
  def up
    remove_column :purchases, :sale_id
  end

  def down
    add_column :purchases, :sale_id, :null => false
  end
end
