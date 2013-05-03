class AddSourceToSales < ActiveRecord::Migration
  def change
    add_column :sales, :source, :string
  end
end