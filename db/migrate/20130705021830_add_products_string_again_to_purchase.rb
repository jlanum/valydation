class AddProductsStringAgainToPurchase < ActiveRecord::Migration
  def change
    remove_column :purchases, :products_email
    
  end
end
