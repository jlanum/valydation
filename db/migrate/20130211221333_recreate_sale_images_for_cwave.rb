class RecreateSaleImagesForCwave < ActiveRecord::Migration
  def up
    #Sale.all.each do |sale|
      #begin
        #puts "sale #{sale.id}"
        #if sale.image_0
          #puts "0"
          #sale.image_0.recreate_versions!
        #end
        #if sale.image_1
          #puts "1"
          #sale.image_1.recreate_versions!
        #end
        #if sale.image_2
          #puts "2"
          #sale.image_2.recreate_versions!
        #end
      #rescue Exception => e
        #puts "error #{e.to_s}"
      #end
      #sale.save
    #end
  end

  def down
  end
end
