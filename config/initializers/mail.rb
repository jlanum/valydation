ActionMailer::Base.smtp_settings = {
  :address  => "pod51042.outlook.com",
  :port  => 587,
  #:domain => "valydation.com",
  :user_name  => "kelly@valydation.com",
  :password  => "cold*567!",
  :authentication       => :login,
  :enable_starttls_auto => true
}

