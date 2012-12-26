class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name, :null => false
      t.timestamps
    end

    add_column :sales, :brand_id, :integer

    add_index :brands, :name
    add_index :sales, :brand_id

    Sale.all.each do |sale|
      sale.set_brand
      sale.save!
    end

  end
end
