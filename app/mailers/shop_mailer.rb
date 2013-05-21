class ShopMailer < ActionMailer::Base
  default from: "/valydation <kelly@valydation.com>"

  def test_email(recip)
    mail(:to => recip, :subject => "Your /valydation purchase is complete!")
  end

  def contact_email(from_name, from_email, subject, body)
    @from_name = from_name
    @from_email = from_email
    @subject = subject
    @body = body

    mail(:to => "kelly@valydation.com",
         :subject => subject)
  end

end
