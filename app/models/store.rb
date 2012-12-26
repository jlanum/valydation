class Store < ActiveRecord::Base
  attr_accessible :name, :url
  has_many :sales
end
