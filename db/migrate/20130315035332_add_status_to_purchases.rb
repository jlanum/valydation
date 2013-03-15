class AddStatusToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :retailer_status, :string, :length => 16
  end
end
