class AddSentEmailsToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :sent_initial_email, :boolean, :default => false
  end
end
