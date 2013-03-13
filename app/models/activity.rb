class Activity < ActiveRecord::Base
  attr_accessible :user_id, :sale_id, :message, :actor_id, :special_key

  belongs_to :user
  belongs_to :sale
  belongs_to :actor, :class_name => "User"

end
