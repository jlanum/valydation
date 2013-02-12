class AddMoreCities < ActiveRecord::Migration
  def up
    ["Atlanta",
     "Boston",
     "Brooklyn",
     "Chicago",
     "Dallas",
     "Honolulu",
     "Houston",
     "Los Angeles",
     "Miami",
     "New York",
     "Orange County"].each do |city_name|

       City.create!(:name => city_name)

     end
  end

  def down
    ["Atlanta",
     "Boston",
     "Brooklyn",
     "Chicago",
     "Dallas",
     "Honolulu",
     "Houston",
     "Los Angeles",
     "Miami",
     "New York",
     "Orange County"].each do |city_name|
       city = City.find_by_name(city_name)
       city.destroy
     end
  end
end
