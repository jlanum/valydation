class Follower < ActiveRecord::Base
  attr_accessible :follower_id, :following_id

  belongs_to :followed_user, :class_name => "User", :foreign_key => "following_id"
  belongs_to :following_user, :class_name => "User", :foreign_key => "follower_id"

end
