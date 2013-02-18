class ShopMailer < ActionMailer::Base
  default from: "MySaleTable <shop@mysaletable.com>"

  def test_email(recip)
    mail(:to => recip, :subject => "Your MySaleTable purchase is complete!")
  end

end
