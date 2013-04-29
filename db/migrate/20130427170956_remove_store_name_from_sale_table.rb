class RemoveStoreNameFromSaleTable < ActiveRecord::Migration
  def change
    remove_column :sales, :store_name
  end
end