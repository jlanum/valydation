class AddTestUser < ActiveRecord::Migration
  def up
    u = User.create(:name => "JoJoMcGee",
                    :email => "max@empire.mn",
                    :passwd_hash => "xyz")

    img = File.open("#{Rails.root}/public/test_images/gorilla.jpg")
    u.photo = img
    u.save!

    Sale.find(:all).each do |s|
      s.user = u
      s.save!
    end
  end

  def down
    User.find_by_name("JoJoMcGee").delete
  end
end
