class AddProductWearToSale < ActiveRecord::Migration
  def change
   add_column :sales, :product_condition, :text
  end
end
  