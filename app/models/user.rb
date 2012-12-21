class User < ActiveRecord::Base
  attr_accessible :name, :email, :passwd_hash, :fb_id
  #validates :name, :format => {:with => /\A\w+\Z/}

  has_many :faves, :class_name => "Fave", :dependent => :destroy
  has_many :comments, :dependent => :destroy

  mount_uploader :photo, UserPhotoUploader

  def self.public_json
    {:only => [:id, :photo, :name]}
  end

end
