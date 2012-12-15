class AddSizeToSale < ActiveRecord::Migration
  def change
    add_column :sales, :size, :string, :limit => 32
  end
end
