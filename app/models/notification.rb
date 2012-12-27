class Notification < ActiveRecord::Base
  attr_accessible :user_id,
                  :device_id,
                  :alert,
                  :sound,
                  :expiry,
                  :badge,
                  :custom,
                  :sent,
                  :sent_at

end
