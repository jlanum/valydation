class AddUploaderImageColumns < ActiveRecord::Migration
  def change
    add_column :sales, :image_0, :string
    add_column :sales, :image_1, :string
    add_column :sales, :image_2, :string
  end
end
