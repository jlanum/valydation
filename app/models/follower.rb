class Follower < ActiveRecord::Base
  attr_accessible :follower_id, :following_id
  #follower_id is the one who has initiated
  #following_id is the one who is being followed
  #
  belongs_to :followed_user, :class_name => "User", :foreign_key => "following_id"
  #followed_user is the one being followed
  belongs_to :following_user, :class_name => "User", :foreign_key => "follower_id"
  #following_user is the one who initiated 
  
  def notification_source_key
    "#{self.following_id} #{self.follower_id}"
  end

  def create_notifications!(recreate = false)
    if self.created_notifications and not recreate
      return false
    elsif Notification.where(:source_type => "Follower",
                             :source_key => self.notification_source_key).first and not recreate
      return false
    end

    notifications = []
    alert_message = "#{self.following_user.display_name} is now following your sales."
    alert_custom = {"user_id" => self.following_user.id}

    if self.followed_user.notify_followed
      self.followed_user.devices.each do |device|
        n = Notification.new(:user_id => self.followed_user.id,
                             :device_id => device.id,
                             :source_type => "Follower",
                             :source_key => self.notification_source_key,
                             :alert => alert_message,
                             :custom => alert_custom.to_json)
        n.save
        notifications << n
      end
    end

    self.created_notifications = true
    self.created_notifications_at = Time.now
    self.save
    
    notifications
  end

end
