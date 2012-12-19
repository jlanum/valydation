class CreateFaves < ActiveRecord::Migration
  def change
    create_table :faves do |t|
      t.integer :user_id, :null => false
      t.integer :sale_id, :null => false
      t.timestamps
    end

    add_index :faves, :sale_id
    add_index :faves, :user_id
  end
end
