def send_emails
  

  User.where(:sent_welcome_email => false).limit(10).each do |user|
    puts "sending welcome email for user #{user.id}"

    user.send_welcome_email
    user.sent_welcome_email = true
    user.save
  end
end
