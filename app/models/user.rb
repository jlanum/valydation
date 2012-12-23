require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :first_name,
                  :last_name,
                  :email, 
                  :passwd_hash, 
                  :fb_id,
                  :city_id,
                  :zip_code

  #validates :name, :format => {:with => /\A\w+\Z/}

  has_many :faves, :class_name => "Fave", :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :devices
  belongs_to :city

  mount_uploader :photo, UserPhotoUploader

  def self.public_json
    {:only => [:id, :name],
     :methods => [:photo_fb]}
  end

  def photo_fb
    if self.fb_id
      base_url = "http://graph.facebook.com/#{self.fb_id}/picture"
      {"url"=>base_url,
       "feed_2x"=>{"url"=>"#{base_url}?type=normal"},
       "feed"=>{"url"=>"#{base_url}?type=small"}}
    else
      JSON.parse(self.photo.to_json)["photo"]
    end
  end

  def passwd_clear=(passwd_clear)
    self.passwd_hash = BCrypt::Password.create(passwd_clear)
  end

  def passwd_clear
    BCrypt::Password.new(self.passwd_hash)
  end

end
