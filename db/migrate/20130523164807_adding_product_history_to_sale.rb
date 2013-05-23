class AddingProductHistoryToSale < ActiveRecord::Migration
  def change
   add_column :sales, :product_history, :string
  end
end
