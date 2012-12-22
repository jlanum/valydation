class AddZipAndCities < ActiveRecord::Migration
  def change
    add_column :users, :zip_code, :string
    add_column :users, :city_id, :integer
    add_column :sales, :city_id, :integer
  end

end
