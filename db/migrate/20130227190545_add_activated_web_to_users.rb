class AddActivatedWebToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activated_web, :boolean, :default => false
  end
end
