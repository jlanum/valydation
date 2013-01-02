class AddTestUser < ActiveRecord::Migration
  def up
    u = User.new
    u.first_name = "Jojo"
    u.last_name = "McGee"
    u.email = "max@empire.mn"
    u.passwd_hash = "xyz"

    img = File.open("#{Rails.root}/public/test_images/gorilla.jpg")
    u.photo = img
    u.save!

    Sale.find(:all).each do |s|
      s.user = u
      s.save!
    end
  end

  def down
    User.where(:first_name => "Jojo", :last_name => "McGee").first.delete
  end
end
