class RemoveVariablesFromSale < ActiveRecord::Migration
  def change
    add_column :sales, :shipping_price, :decimal, :precision => 8, :scale => 2 
    add_column :sales, :tax_cost, :decimal, :precision => 8, :scale => 2
    add_column :sales, :condition, :string 
    add_column :sales, :validated, :boolean, :default => false
  end
end