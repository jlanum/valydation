class AddSizesToSales < ActiveRecord::Migration
  def change
    add_column :sales, :sizes, :string_array
    add_index :sales, :sizes
    add_index :sales, [:category_id, :sizes, :created_at]

    Sale.all.each { |s| s.save! } #set value from size attr
  end
end
