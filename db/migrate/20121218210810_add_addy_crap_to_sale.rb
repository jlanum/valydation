class AddAddyCrapToSale < ActiveRecord::Migration
  def change
    add_column :sales, :latitude, :float
    add_column :sales, :longitude, :float
    add_column :sales, :address, :string
    add_column :sales, :city, :string
    add_column :sales, :state, :string
    add_column :sales, :postal_code, :string
    add_column :sales, :country, :string
  end
end
