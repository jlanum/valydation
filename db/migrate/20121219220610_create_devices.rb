class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :duid, :null => false
      t.string :apns_token
      t.integer :user_id
      t.timestamps
    end
  end
end
