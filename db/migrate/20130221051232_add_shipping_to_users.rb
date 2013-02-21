class AddShippingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :does_shipping, :boolean, :default => false
  end
end
