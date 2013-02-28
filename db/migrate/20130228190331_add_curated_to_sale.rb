class AddCuratedToSale < ActiveRecord::Migration
  def change
    add_column :sales, :editors_pick, :boolean, :default => false

    add_index :sales, :editors_pick
  end
end
