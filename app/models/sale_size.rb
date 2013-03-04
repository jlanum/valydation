class SaleSize < ActiveRecord::Base
  attr_accessible :value, :sale_id
  belongs_to :sale
end
