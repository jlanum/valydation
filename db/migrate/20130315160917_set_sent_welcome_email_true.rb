class SetSentWelcomeEmailTrue < ActiveRecord::Migration
  def up
    User.all.each { |u| u.sent_welcome_email = true; u.save }
  end

  def down
  end
end
