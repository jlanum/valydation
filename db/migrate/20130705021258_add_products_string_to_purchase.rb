class AddProductsStringToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :products_email, :string
    
  end
end
  