class User < ActiveRecord::Base
  has_many :faves, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  mount_uploader :photo, UserPhotoUploader
end
