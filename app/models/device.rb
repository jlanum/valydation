class Device < ActiveRecord::Base
  attr_accessible :apns_token, :duid
  belongs_to :user

end
