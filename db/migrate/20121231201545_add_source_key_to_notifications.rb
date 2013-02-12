class AddSourceKeyToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :source_key, :string
  end
end
