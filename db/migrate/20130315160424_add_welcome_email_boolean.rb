class AddWelcomeEmailBoolean < ActiveRecord::Migration
  def change
    add_column :users, :sent_welcome_email, :boolean, :default => false
  end
 # User.all.each { |u| u.sent_welcome_email = true; u.save }
end
