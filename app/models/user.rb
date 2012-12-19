class User < ActiveRecord::Base
  attr_accessible :name, :email, :passwd_hash

  has_many :faves, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  mount_uploader :photo, UserPhotoUploader
end
