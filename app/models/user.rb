require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :first_name,
                  :last_name,
                  :email, 
                  :passwd_hash,
                  :passwd_clear, 
                  :fb_id,
                  :city_id,
                  :zip_code,
                  :bio,
                  :notify_faved,
                  :notify_followed,
                  :notify_posted,
                  :notify_comment,
                  :business_name,
                  :custom_slug,
                  :bio,
                  :website_url,
                  :is_merchant

  attr_accessor :other_user

  #validates :name, :format => {:with => /\A\w+\Z/}

  has_many :faves, :class_name => "Fave", :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :devices
  belongs_to :city
  has_many :sales, :order => "created_at DESC"

  #following/followed_users are the users who this user is following
  has_many :following, :class_name => "Follower", :foreign_key => "follower_id"
  has_many :followed_users, :through => :following, :class_name => "User"

  #followed/following_users are the users following this user
  has_many :followed, :class_name => "Follower", :foreign_key => "following_id"
  has_many :following_users, :through => :followed, :class_name => "User"

  mount_uploader :photo, UserPhotoUploader

  def self.public_json
    {:only => [:id, :first_name, :last_name, :city_id],
     :methods => [:photo_fb, :display_name]}
  end

  def self.public_json_follow
    opts = self.public_json
    opts[:methods] << :is_followed
    opts
  end

  def follower_count
    self.followed.count
  end

  def following_count
    self.following.count
  end

  def display_name
    "#{self.first_name} #{self.last_name}"
  end

  def unregister_push!
    self.notify_faved = false
    self.notify_followed = false
    self.notify_posted = false
    self.notify_comment = false
    self.save
    self
  end

  def photo_fb
    if self.fb_id
      base_url = "http://graph.facebook.com/#{self.fb_id}/picture"
      {"url"=>base_url,
       "feed_2x"=>{"url"=>"#{base_url}?type=normal"},
       "feed"=>{"url"=>"#{base_url}?type=small"},
       "follower_2x"=>{"url"=>"#{base_url}?type=normal"},
       "follower"=>{"url"=>"#{base_url}?type=normal"},
       "profile_2x"=>{"url"=>"#{base_url}?type=large"},
       "profile"=>{"url"=>"#{base_url}?type=large"}
      }
    else
      JSON.parse(self.photo.to_json)["photo"]
    end
  end

  def default_avatar
    {
     "feed" => "/assets/default_avatar_36.png",
     "feed_2x" => "/assets/default_avatar_36@2x.png",
     "follower" => "/assets/default_avatar_44.png",
     "follower_2x" => "/assets/default_avatar_44@2x.png",
     "profile" => "/assets/default_avatar_140.png",
     "profile_2x" => "/assets/default_avatar_140@2x.png"
    }
  end
  
  def photo_version_url(version)
    url = self.photo_fb[version.to_s]["url"]
    url || self.default_avatar[version.to_s]
  end

  def is_followed
    raise "no other user!" unless self.other_user
    return nil if self.other_user.id == self.id
    self.followed.where("follower_id" => self.other_user.id).first
  end

  def passwd_clear=(passwd_clear)
    self.passwd_hash = BCrypt::Password.create(passwd_clear)
  end

  def passwd_clear
    BCrypt::Password.new(self.passwd_hash)
  end


  def detach_devices!(device_to_detach = false)
    unless device_to_detach
      raise "Pass a device or a true argument to this method if you really mean it. It will permanently destroy the devices that belong to this user and assign it a fake device."
    end
    
    new_device = Device.new
    new_device.randomize_duid
    new_device.save!
    
    if device_to_detach.kind_of?(Device)
      device_to_detach.destroy
    else
      self.devices.destroy_all
    end
    
    new_device.user = self
    new_device.save
    
    self.devices.reload
  end

end