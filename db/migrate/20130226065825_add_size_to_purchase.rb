class AddSizeToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :size, :string
  end
end
