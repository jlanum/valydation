class ShopMailer < ActionMailer::Base
  default from: "/valydation <kelly@valydation.com>"

  def test_email(recip)
    mail(:to => recip, :subject => "Your /valydation purchase is complete!")
  end
  
  def create_and_deliver_passwd_change(user, random_password)
    @user = user
    @random_password = random_password
    mail(:to => user.email, 
         :subject => 'Here is your new /valydation password')
  end

  def contact_email(from_name, from_email, subject, body)
    @from_name = from_name
    @from_email = from_email
    @subject = subject
    @body = body

    mail(:to => "kelly@valydation.com",
         :subject => subject)
    end
  

  def consignment_email(from_name, from_email, subject, body, city, state, country, zip_code, phone_number)
    @from_name = from_name
    @from_email = from_email
    @subject = subject
    @body = body
    @city = city
    @state = state
    @country = country
    @zip_code = zip_code
    @phone_number = phone_number

    mail(:to => "kelly@valydation.com",
         :subject => subject)
      
    end
  end

