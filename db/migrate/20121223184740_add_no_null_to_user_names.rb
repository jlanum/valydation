class AddNoNullToUserNames < ActiveRecord::Migration
  def change
    test_user = User.find_by_email("max@empire.mn")
    test_user.first_name = "Jojo"
    test_user.last_name = "McGee"
    test_user.email = "jojo@empire.mn"
    test_user.save!

    change_column :users, :first_name, :string, :null => false
    change_column :users, :last_name, :string, :null => false
  end
end
