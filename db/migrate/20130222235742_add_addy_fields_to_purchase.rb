class AddAddyFieldsToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :subtotal_cents, :integer
    add_column :purchases, :tax_cents, :integer
    add_column :purchases, :shipping_cents, :integer
    add_column :purchases, :total_cents, :integer
  
    add_column :purchases, :address, :string
    add_column :purchases, :address_2, :string
    add_column :purchases, :city, :string
    add_column :purchases, :state, :string
    add_column :purchases, :zip, :string
  end
end
