class AddDisplayOrderToStores < ActiveRecord::Migration
  def change
    add_column :users, :display_order, :integer, :default => 0
  end
end
