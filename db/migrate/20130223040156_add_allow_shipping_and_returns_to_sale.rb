class AddAllowShippingAndReturnsToSale < ActiveRecord::Migration
  def change
    remove_column :users, :does_shipping
    remove_column :users, :allow_returns

    add_column :sales, :does_shipping, :boolean, :default => false
    add_column :sales, :allow_returns, :boolean, :default => false
  end
end
