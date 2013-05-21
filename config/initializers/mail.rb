ActionMailer::Base.smtp_settings = {
  :address  => "pod51042.outlook.com",
  :port  => 587,
  #:domain => "mysaletable.com",
  :user_name  => "kelly@valydation.com",
  :password  => "Green1994",
  :authentication       => :login,
  :enable_starttls_auto => true
}

