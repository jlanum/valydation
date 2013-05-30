class FixingProductHistoryToSale < ActiveRecord::Migration
  def change
   remove_column :sales, :product_history
   
   add_column :sales, :product_history, :text
  end
end
 