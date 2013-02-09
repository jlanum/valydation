class AddGenderToUser < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string, :limit => 1
  end
end
