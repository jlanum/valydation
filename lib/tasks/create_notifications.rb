NOTIFY_SLEEP = 600

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


if ARGV.include?("--loop")
  loop do 
    puts "creating notifications" 
    create_notifications
    puts "Sleeping #{NOTIFY_SLEEP}."
    sleep NOTIFY_SLEEP
  end
else
  create_notifications
end
