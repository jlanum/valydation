class AddTempImageUrlsToSale < ActiveRecord::Migration
  def change
    add_column :sales, :temp_image_url_0, :string
    add_column :sales, :temp_image_url_1, :string
    add_column :sales, :temp_image_url_2, :string

    add_column :sales, :visible, :boolean, :default => false
    add_column :sales, :uploaded_images, :boolean, :default => false
    add_column :sales, :processed_images, :boolean, :default => false

    Sale.all.each do |s|
      s.visible = true
      s.processed_images = true
      s.save
    end
  end
end
