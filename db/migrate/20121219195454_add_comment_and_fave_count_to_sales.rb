class AddCommentAndFaveCountToSales < ActiveRecord::Migration
  def change
    add_column :sales, :comment_count, :integer, :default => 0
    add_column :sales, :fave_count, :integer, :default => 0
  end
end
