class AddCities < ActiveRecord::Migration
  def change
    ["Atlanta",
     "Austin",
     "Baltimore",
     "Boston",
     "Brooklyn",
     "Chicago",
     "Cleveland",
     "Dallas",
     "Denver",
     "Houston",
     "Honolulu",
     "Las Vegas",
     "Los Angeles",
     "Marin County",
     "Miami",
     "Minneapolis",
     "Napa Valley",
     "Nashville",
     "New Orleans",
     "New York City",
     "Orange County",
     "Philidelphia",
     "Phoenix-Scottsdale",
     "Portland",
     "San Diego",
     "San Francisco",
     "Silicon Valley",
     "Santa Barbara",
     "Seattle",
     "Washington D.C."].each do |city_name|
       unless City.where(:name => city_name).first
         City.create(:name => city_name)
       end
     end
  end

end
