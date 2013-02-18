def send_emails
  Purchase.where(:sent_initial_email => false).limit(10).each do |purchase|
    puts "sending email for purchase #{purchase.id}"
    ##send email

    purchase.sent_initial_email = true
    purchase.save
  end
end
