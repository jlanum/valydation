class AddPriorityToSales < ActiveRecord::Migration
  def change
    add_column :sales, :product_priority, :integer, :default => 5
  end
end
