class AddLatLonToCities < ActiveRecord::Migration
  def change
    add_column :cities, :lat, :float
    add_column :cities, :lon, :float

    city_coords = {
      "Atlanta" => [33.755, -84.39],
      "Austin" => [30.25, -97.75],
      "Baltimore" => [39.283333, -76.616667],
      "Boston" => [42.358056, -71.063611],
      "Brooklyn" => [40.624722, -73.952222],
      "Chicago" => [41.881944, -87.627778],
      "Cleveland" => [41.482222, -81.669722],
      "Dallas" => [32.782778, -96.803889],
      "Denver" => [39.739167, -104.984722],
      "Honolulu" => [21.308889, -157.826111],
      "Houston" => [29.762778, -95.383056],
      "Las Vegas" => [36.175, -115.136389],
      "Los Angeles" => [34.05, -118.25],
      "Marin County" => [38.04, -122.74],
      "Miami" => [25.787676, -80.224145],
      "Minneapolis" => [44.983333, -93.266667],
      "Napa Valley" => [38.5, -122.32],
      "Nashville" => [36.166667, -86.783333],
      "New Orleans" => [29.966667, -90.05],
      "New York City" => [40.790278, -73.959722],
      "Orange County" => [33.67, -117.78],
      "Philidelphia" => [39.95, -75.17],
      "Phoenix-Scottsdale" => [33.45, -112.066667],
      "Portland" => [45.52, -122.681944],
      "San Diego" => [32.715, -117.1625],
      "San Francisco" => [37.783333, -122.416667],
      "Santa Barbara" => [34.425833, -119.714167],
      "Seattle" => [47.609722, -122.333056],
      "Silicon Valley" => [37.429167, -122.138056],
      "Washington D.C." => [38.895111, -77.036667]
    }

    city_coords.each_pair do |city_name, coord_pair|
      city = City.where(:name => city_name).first
      city.lat = coord_pair.first
      city.lon = coord_pair.last
      city.save
    end

  end
end
