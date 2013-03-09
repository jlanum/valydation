class AddSoldOutToSale < ActiveRecord::Migration
  def change
    add_column :sales, :sold_out, :boolean, :default => false
  end
end
