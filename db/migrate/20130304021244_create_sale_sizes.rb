class CreateSaleSizes < ActiveRecord::Migration
  def change
    create_table :sale_sizes do |t|
      t.integer :sale_id      
      t.string :value
      t.timestamps
    end

    add_index :sale_sizes, :sale_id
    add_index :sale_sizes, :value
    add_index :sale_sizes, [:value, :sale_id]

    Sale.all.each { |s| s.save! }
  end
end
