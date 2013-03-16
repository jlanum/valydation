class CreateSaleGroups < ActiveRecord::Migration
  def change
    create_table :sale_groups do |t|
      t.string :name, :limit => 64, :null => false
      t.string :slug, :limit => 64, :null => false
      t.boolean :featured, :default => false
      t.timestamps
    end

    add_column :sales, :sale_group_id, :integer
    add_column :sales, :group_curated, :boolean

    add_index :sales, :sale_group_id
    add_index :sale_groups, :slug, :unique => true
  end
end
