class FixHasImageFlag < ActiveRecord::Migration
  def change
    add_column :sales, :has_image_0, :boolean
    remove_column :sales, :has_image_3
  end
end
