class AddNotifyCommentsStuff < ActiveRecord::Migration
  def change
    add_column :users, :notify_comment, :boolean, :default => true
    add_column :comments, :created_notifications, :boolean, :default => false
    add_column :comments, :created_notifications_at, :datetime
  end
end
