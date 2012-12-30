class Notification < ActiveRecord::Base
  attr_accessible :user_id,
                  :device_id,
                  :alert,
                  :sound,
                  :expiry,
                  :badge,
                  :custom,
                  :sent,
                  :sent_at,
                  :source_type,
                  :source_id

  belongs_to :user
  belongs_to :device

  def send!(pusher)
    begin
      notif = Grocer::Notification.
        new(:device_token => self.device.apns_token,
            :alert => self.alert,
            :badge => self.badge)
      if self.custom
        notif.custom = JSON.parse(self.custom)
      end
      unless self.device.apns_token.nil? or 
             self.device.apns_token.match(/31337000/)
        pusher.push(notif) 
      end
      self.sent = true
      self.sent_at = Time.now
      self.save
    rescue Exception => e
      self.retries += 1
      self.save
      raise e
    end
    self
  end
end
