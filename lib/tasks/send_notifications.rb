NOTIFY_SLEEP = 600


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


if ARGV.include?("--loop")
  loop do 
    puts "pushing" 
    push
    feedback
    puts "Sleeping #{NOTIFY_SLEEP}."
    sleep NOTIFY_SLEEP
  end
else
  push
  feedback
end

