class AddUniqueConstrainsToUsers < ActiveRecord::Migration
  def change
    add_index :users, :email, :unique => true
    add_index :users, :fb_id, :unique => true
  end
end
