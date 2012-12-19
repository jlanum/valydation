class AddTestUser < ActiveRecord::Migration
  def up
    User.create(:name => "Test McGee",
                :email => "max@empire.mn",
                :passwd_hash => "xyz")
  end

  def down
    User.find_by_name('Test McGee').destroy
  end
end
