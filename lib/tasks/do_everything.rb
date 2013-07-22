# load "#{File.dirname(__FILE__)}/create_notifications.rb"
load "#{File.dirname(__FILE__)}/process_images.rb"
load "#{File.dirname(__FILE__)}/send_emails.rb"

NOTIFY_SLEEP = 10

def do_errthing
    #puts "processing sales"
    process_sales

    #puts "creating notifications" 
    create_notifications
    #puts "sending notifications"
    push
    #puts "feedback"
    feedback
  
    send_emails

    #puts "Sleeping #{NOTIFY_SLEEP}."  
end

if ARGV.include?("--loop")
  loop do 
    do_errthing
    sleep NOTIFY_SLEEP
  end
else
  do_errthing
end
