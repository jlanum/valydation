class Comment < ActiveRecord::Base
  attr_accessible :user_id, :sale_id, :text
  belongs_to :user
  belongs_to :sale

  after_create :count_comments_for_sale
  after_destroy :count_comments_for_sale

  def count_comments_for_sale
    self.sale.comment_count = self.sale.comments.count
    self.sale.save!
  end

end
