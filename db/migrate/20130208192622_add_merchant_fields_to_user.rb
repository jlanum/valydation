class AddMerchantFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_merchant, :bool, :default => false
    add_column :users, :retail_category, :string
    add_column :users, :business_name, :string
    add_column :users, :custom_slug, :string, :unique => true
    add_column :users, :website_url, :text

    add_index :users, :custom_slug
  end
end
