class RemoveShippingOnSale < ActiveRecord::Migration
   def change
      remove_money :sales, :shipping_price
      remove_money :sales, :tax_cost

      
    end
  end
