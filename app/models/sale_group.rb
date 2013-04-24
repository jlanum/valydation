class SaleGroup < ActiveRecord::Base
  attr_accessible :name, :slug, :featured
  
  has_many :sales

  def featured_sale
    @featured_sale ||= self.sales.where(:visible => true).
      order("sales.group_curated DESC, sales.updated_at DESC").first
  end

end
