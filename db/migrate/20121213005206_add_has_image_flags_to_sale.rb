class AddHasImageFlagsToSale < ActiveRecord::Migration
  def change
    add_column :sales, :has_image_1, :boolean
    add_column :sales, :has_image_2, :boolean
    add_column :sales, :has_image_3, :boolean
  end
end
