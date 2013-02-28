class AddCustomSlugLower < ActiveRecord::Migration
  def up
    add_column :users, :custom_slug_lower, :string
    add_index :users, :custom_slug_lower, :unique => true

    User.all.each do |u|
      u.save!
    end
  end

  def down
    remove_column :users, :custom_slug_lower
    remove_index :users, :custom_slug_lower
  end
end
