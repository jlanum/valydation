class Fave < ActiveRecord::Base
  attr_accessible :user_id, :sale_id

  belongs_to :user
  belongs_to :sale

  after_create :count_faves_for_sale
  after_destroy :count_faves_for_sale

  def create_notifications!(recreate = false)
    if self.created_notifications and not recreate
      return false
    elsif Notification.where(:source_type => "Fave",
                             :source_id => self.sale.id).first and not recreate
      return false
    elsif not self.sale or not self.sale.user
      return false
    end

    notifications = []
    
    if self.sale.user.notify_faved
      self.sale.user.devices.each do |device|
        n = Notification.new(:user_id => self.sale.user_id,
                             :device_id => device.id,
                             :source_type => "Fave",
                             :source_id => self.sale.id,
                             :alert => "Somebody faved your sale!")
        n.save
        notifications << n
      end
    end

    self.created_notifications = true
    self.created_notifications_at = Time.now
    self.save

    notifications
  end

  def count_faves_for_sale
    self.sale.fave_count = self.sale.faves.count
    self.sale.save!
  end

end
