class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id, :null => false
      t.integer :sale_id, :null => false
      t.integer :actor_id, :null => false
      t.string :special_key, :limit => 24
      t.text :message

      t.timestamps
    end

    add_index :activities, :user_id
    add_index :activities, [:user_id, :created_at], :order => {:user_id => :asc, :created_at => :desc}
    add_index :activities, :special_key
  end
end
