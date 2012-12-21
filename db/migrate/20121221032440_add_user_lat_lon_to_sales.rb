class AddUserLatLonToSales < ActiveRecord::Migration
  def change
    add_column :sales, :user_lat, :float
    add_column :sales, :user_lon, :float
  end
end
