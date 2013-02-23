class RealyAddShipToSale < ActiveRecord::Migration
  def up
    remove_column :users, :does_shipping
    remove_column :users, :allow_returns
    
    add_column :sales, :does_shipping, :boolean, :default => false
    add_column :sales, :allow_returns, :boolean, :default => false
  end

  def down
    remove_column :sales, :does_shipping
    remove_column :sales, :allow_returns
    
    add_column :users, :does_shipping, :boolean, :default => false
    add_column :users, :allow_returns, :boolean, :default => false    
  end
end
