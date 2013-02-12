class AddUserStuff < ActiveRecord::Migration
  def change
    add_column :users, :bio, :text
    add_column :users, :notify_faved, :boolean
    add_column :users, :notify_followed, :boolean
    add_column :users, :notify_posted, :boolean
  end
end
