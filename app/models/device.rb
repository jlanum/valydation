class Device < ActiveRecord::Base
  attr_accessible :apns_token, :duid
  belongs_to :user

  def randomize_duid
    self.duid = (0..31).inject("") { |s| s << rand(("0".ord)..("z".ord)) }
  end
  
end
