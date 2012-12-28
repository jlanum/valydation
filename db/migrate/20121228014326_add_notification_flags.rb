class AddNotificationFlags < ActiveRecord::Migration
  def change
    add_column :sales, :created_notifications, :boolean, :default => false
    add_column :sales, :created_notifications_at, :datetime
    add_column :faves, :created_notifications, :boolean, :default => false
    add_column :faves, :created_notifications_at, :datetime
    add_column :followers, :created_notifications, :boolean, :default => false
    add_column :followers, :created_notifications_at, :datetime

    add_index :sales, :created_notifications
    add_index :faves, :created_notifications
    add_index :followers, :created_notifications
  
    add_column :notifications, :source_type, :string
    add_column :notifications, :source_id, :integer
  end
end
