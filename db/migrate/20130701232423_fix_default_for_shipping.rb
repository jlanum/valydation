class FixDefaultForShipping < ActiveRecord::Migration
  def change
   remove_column :purchases, :ship_it
   
   add_column :purchases, :ship_it, :boolean, :default => true
  end
end