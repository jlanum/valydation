class AddStoreAddyToUser < ActiveRecord::Migration
  def change
    add_column :users, :store_address, :text
  end
end
