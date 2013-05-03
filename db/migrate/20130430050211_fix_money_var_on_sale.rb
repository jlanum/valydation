class FixMoneyVarOnSale < ActiveRecord::Migration
  def change
    remove_column :sales, :shipping_price
    remove_column :sales, :tax_cost
    
    add_money :sales, :shipping_price
    add_money :sales, :tax_cost
  end
end