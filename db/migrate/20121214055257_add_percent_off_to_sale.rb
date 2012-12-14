class AddPercentOffToSale < ActiveRecord::Migration
  def change
    add_column :sales, :percent_off, :float
  end
end
