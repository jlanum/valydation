class Fave < ActiveRecord::Base
  belongs_to :user
  belongs_to :sale

  after_create :count_faves_for_sale
  after_destroy :count_faves_for_sale

  def count_faves_for_sale
    self.sale.fave_count = self.sale.faves.count
    self.sale.save!
  end

end
