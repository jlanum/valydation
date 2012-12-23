require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :first_name,
                  :last_name,
                  :email, 
                  :passwd_hash,
                  :passwd_clear, 
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
