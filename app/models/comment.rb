class Comment < ActiveRecord::Base
  attr_accessible :user_id, :sale_id, :text
  belongs_to :user
  belongs_to :sale

  after_create :count_comments_for_sale
  after_destroy :count_comments_for_sale

  def count_comments_for_sale
    self.sale.comment_count = self.sale.comments.count
    self.sale.save!
  end

  def create_notifications!(recreate = false)
    if self.created_notifications and not recreate
      return false
    elsif Notification.where(:source_type => "Comment",
                             :source_id => self.id).first and not recreate
      return false
    elsif not self.user or not self.sale or not self.sale.user
      return false
    elsif self.user_id == self.sale.user_id
      return false
    end

    notifications = []
    
    alert_message = "#{self.user.display_name} commented on your sale."
    alert_custom = {"user_id" => self.user_id,
                    "sale_id" => self.sale_id}

    if self.sale.user.notify_comment
      self.sale.user.devices.each do |device|
        n = Notification.new(:user_id => self.sale.user_id,
                             :device_id => device.id,
                             :source_type => "Comment",
                             :source_id => self.id,
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
