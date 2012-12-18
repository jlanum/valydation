class FixMoneyColumnsOnSale < ActiveRecord::Migration
  def change
    remove_column :sales, :orig_price
    remove_column :sales, :sale_price
    
    add_money :sales, :orig_price
    add_money :sales, :sale_price
  end
end
