ActionMailer::Base.smtp_settings = {
  :address  => "pod51010.outlook.com",
  :port  => 587,
  #:domain => "mysaletable.com",
  :user_name  => "shop@mysaletable.com",
  :password  => "Green1994",
  :authentication       => :login,
  :enable_starttls_auto => true
}

