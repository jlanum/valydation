class AddProductSpecificsToSale < ActiveRecord::Migration
  def change
   add_column :sales, :product_specifics, :text
  end
end
