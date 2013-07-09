class AddProductsStringAgainToPurchase < ActiveRecord::Migration
  def change
    remove_column :purchases, :products_email, :string
    
  end
end
