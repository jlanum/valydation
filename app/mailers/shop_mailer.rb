class ShopMailer < ActionMailer::Base
  default from: "/valydation <kelly@valydation.com>"

  def test_email(recip)
    mail(:to => recip, :subject => "Your /valydation purchase is complete!")
  end
  
  def create_and_deliver_passwd_change(user, passwd_hash)
    @user = user
    @passwd_hash = passwd_hash
    mail(:to => @user.email, :subject => "Your /valydation password change is complete!")
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

