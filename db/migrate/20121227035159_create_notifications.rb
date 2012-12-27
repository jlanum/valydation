class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id, :null => false
      t.integer :device_id, :null => false
      t.string :alert, :null => false
      t.string :sound
      t.integer :expiry
      t.integer :badge
      t.text :custom
      t.boolean :sent
      t.datetime :sent_at
      t.timestamps
    end

    add_index :notifications, :sent
  end
end
