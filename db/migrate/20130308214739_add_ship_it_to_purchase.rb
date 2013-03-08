class AddShipItToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :ship_it, :boolean, :default => false
  end
end
