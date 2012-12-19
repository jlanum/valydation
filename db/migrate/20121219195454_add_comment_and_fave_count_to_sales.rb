class AddCommentAndFaveCountToSales < ActiveRecord::Migration
  def change
    add_column :sales, :comment_count, :integer
    add_column :sales, :fave_count, :integer
  end
end
