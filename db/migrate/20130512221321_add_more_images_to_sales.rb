class AddMoreImagesToSales < ActiveRecord::Migration
  def change
        add_column :sales, :image_3, :string
        add_column :sales, :image_4, :string
        add_column :sales, :image_5, :string
        add_column :sales, :image_6, :string
        add_column :sales, :image_7, :string
        add_column :sales, :has_image_3, :boolean
        add_column :sales, :has_image_4, :boolean
        add_column :sales, :has_image_5, :boolean
        add_column :sales, :has_image_6, :boolean
        add_column :sales, :has_image_7, :boolean
        add_column :sales, :temp_image_url_3, :string
        add_column :sales, :temp_image_url_4, :string
        add_column :sales, :temp_image_url_5, :string
        add_column :sales, :temp_image_url_6, :string
        add_column :sales, :temp_image_url_7, :string
  end
end
