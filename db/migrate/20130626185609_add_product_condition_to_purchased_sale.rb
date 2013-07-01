class AddProductConditionToPurchasedSale < ActiveRecord::Migration
  def change
   add_column :purchased_sales, :product_condition, :text
  end
end