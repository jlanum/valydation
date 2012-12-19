class AddSaleIndexToComments < ActiveRecord::Migration
  def change
    add_index :comments, :sale_id
  end
end
