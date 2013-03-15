def send_emails
  Purchase.where(:sent_initial_email => false).limit(10).each do |purchase|
    puts "sending email for purchase #{purchase.id}"
    ##send email

    purchase.send_initial_emails
    purchase.sent_initial_email = true
    purchase.save
  end

  User.where(:sent_welcome_email => false).limit(10).each do |user|
    puts "sending welcome email for user #{user.id}"

    user.send_welcome_email
    user.sent_welcome_email = true
    user.save
  end
end
