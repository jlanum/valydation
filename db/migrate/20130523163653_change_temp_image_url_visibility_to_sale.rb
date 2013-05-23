class ChangeTempImageUrlVisibilityToSale < ActiveRecord::Migration
  def change
   remove_column :sales, :visible
   
   add_column :sales, :visible, :boolean, :default => true
  end
end
