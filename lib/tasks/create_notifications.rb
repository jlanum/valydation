NOTIFY_SLEEP = 30

def create_notifications
  create_notifications_sales
  create_notifications_faves
  create_notifications_followers
end

def create_notifications_sales
  Sale.where(:created_notifications => false).each do |sale|
    ns = sale.create_notifications!
    puts "Created #{ns.count} notifications for sale #{sale.id}" if ns
  end
end

def create_notifications_faves
  Fave.where(:created_notifications => false).each do |fave|
    ns = fave.create_notifications!
    puts "Created #{ns.count} notifications for fave #{fave.id}" if ns
  end
end

def create_notifications_followers
  Follower.where(:created_notifications => false).each do |follower|
    ns = follower.create_notifications!
    puts "Created #{ns.count} notifications for follower #{follower.id}" if ns
  end
end


def push
  @notifications = Notification.
    where(["sent = ? AND retries < ?", false, 3]).
    order("created_at ASC").
    limit(100).all
  
  if @notifications.length == 0
    return []
  end

  pusher = Grocer.pusher(GrocerConfig)

  @notifications.each do |notification|
    begin
      puts "Sending notification #{notification.id} #{notification.source_type} #{notification.source_id}"
      notification.send!(pusher)
    rescue
      ##loggy?
    end
  end
  
  return @notifications
end

def feedback
  feedback = Grocer.feedback(GrocerConfig)

  @attempts = []

  feedback.each do |response|
    attempt = {:token => response.device_token,
               :timestamp => response.timestamp}
    if device = Device.find_by_apns_token(response.device_token)
      attempt[:device_id] = device.id
      if user = device.user
        user.unregister_push!
        attempt[:user_id] = user.id
      end
    end
    @attempts << attempt
  end

  return @attempts
end

def do_errthing
    puts "creating notifications" 
    create_notifications
    puts "sending notifications"
    push
    puts "feedback"
    feedback
    puts "Sleeping #{NOTIFY_SLEEP}."  
end

if ARGV.include?("--loop")
  loop do 
    do_errthing
    sleep NOTIFY_SLEEP
  end
else
  do_errthing
end
