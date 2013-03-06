class FixCityStateInSale < ActiveRecord::Migration
  def up
    Sale.all.sort.reverse.each do |sale|
      puts sale.id

      place_url = "https://maps.googleapis.com/maps/api/place/details/json?key=#{ApplicationController.google_places_key}&reference=#{sale.store_url}&sensor=false"
      json_response = JSON.parse(open(place_url).read)

      begin
        addy = json_response["result"]["address_components"]
        if locality_hash = addy.find { |h| h["types"].include?("locality") }
          sale.city = locality_hash["long_name"]
        end

        if state_hash = addy.find { |h| h["types"].include?("administrative_area_level_1") }
          sale.state = state_hash["long_name"]
        end

        sale.save!
      rescue Exception => e
        puts "Dang, error"
      end
      
    end
  end

  def down
  end
end
