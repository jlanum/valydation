class AddAllowShippingAndReturnsToSale < ActiveRecord::Migration
  def change
    remove_column :users, :does_shipping
    remove_column :users, :allow_returns

    add_column :users, :does_shipping, :boolean, :default => false
    add_column :users, :allow_returns, :boolean, :default => false
  end
end
