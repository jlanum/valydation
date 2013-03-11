class Fave < ActiveRecord::Base
  attr_accessible :user_id, :sale_id

  belongs_to :user
  belongs_to :sale

  after_create :count_faves_for_sale
  after_destroy :count_faves_for_sale
  after_create :create_activities

  def activity_key
    "#{self.sale_id} #{self.user_id}"
  end

  def create_activities
    if Activity.where(:special_key => self.activity_key).first
      return
    end

    unless self.sale.user_id == self.user_id
      Activity.create(:user_id => self.sale.user_id,
                      :actor_id => self.id,
                      :sale_id => self.sale.id,
                      :special_key => self.activity_key,
                      :message => "#{self.user.display_name} favorited your sale.")
    end

    Activity.create(:user_id => self.user_id,
                    :actor_id => self.user_id,
                    :sale_id => self.sale.id,
                    :special_key => self.activity_key,
                    :message => "You favorited a sale posted by #{self.sale.user.display_name}.")
  end

  def notification_source_key
    "#{self.sale_id} #{self.user_id}"
  end

  def create_notifications!(recreate = false)
    if self.created_notifications and not recreate
      return false
    elsif Notification.where(:source_type => "Fave",
                             :source_key => self.notification_source_key).first and not recreate
      return false
    elsif not self.sale or not self.sale.user
      return false
    end

    notifications = []
    
    alert_message = "#{self.user.display_name} liked your sale."
    alert_custom = {"user_id" => self.user_id}

    if self.sale.user.notify_faved
      self.sale.user.devices.each do |device|
        n = Notification.new(:user_id => self.sale.user_id,
                             :device_id => device.id,
                             :source_type => "Fave",
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

  def count_faves_for_sale
    self.sale.fave_count = self.sale.faves.count
    self.sale.save!
  end

end
