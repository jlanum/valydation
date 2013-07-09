class AddAddyFieldsToPurchasedSales < ActiveRecord::Migration
  def change
    add_column :purchased_sales, :address, :string
    add_column :purchased_sales, :address_2, :string
    add_column :purchased_sales, :city, :string
    add_column :purchased_sales, :state, :string
    add_column :purchased_sales, :zip, :string
  end
end
