class AddAllowReturnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :allow_returns, :boolean, :default => false
  end
end
