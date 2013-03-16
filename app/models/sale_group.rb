class SaleGroup < ActiveRecord::Base
  attr_accessible :name, :slug, :featured

  has_many :sales
end
