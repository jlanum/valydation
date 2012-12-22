class AddInitCity < ActiveRecord::Migration
  def up
    city = City.create(:name => "San Francisco")
    Sale.all.each { |s| s.city = city; s.save }
  end

  def down
    City.find_by_name("San Francisco").destroy
  end
end
