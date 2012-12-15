class AddDisplayAddyToSales < ActiveRecord::Migration
  def change
    add_column :sales, :display_address, :text
  end
end
