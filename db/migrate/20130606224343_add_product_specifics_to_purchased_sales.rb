class AddProductSpecificsToPurchasedSales < ActiveRecord::Migration
  def change
   add_column :purchased_sales, :product_specifics, :text
  end
end