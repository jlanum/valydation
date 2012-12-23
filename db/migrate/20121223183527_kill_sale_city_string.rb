class KillSaleCityString < ActiveRecord::Migration
  def change
    remove_column :sales, :city
  end
end
