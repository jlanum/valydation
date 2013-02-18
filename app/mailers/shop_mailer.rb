class ShopMailer < ActionMailer::Base
  default from: "MySaleTable <shop@mysaletable.com>"

  def test_email(recip)
    mail(:to => recip, :subject => "Your MySaleTable purchase is complete!")
  end

  def contact_email(from_name, from_email, subject, body)
    @from_name = from_name
    @from_email = from_email
    @subject = subject
    @body = body

    mail(:to => "hi@mysaletable.com",
         :subject => subject)
  end

end
