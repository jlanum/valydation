class RecreateSaleImageVersions < ActiveRecord::Migration
  def up
    Sale.all.each do |s|
      begin
        puts "sale #{sale.id}"
        if sale.image_0
          sale.image_0.recreate_versions!
        end
        if sale.image_1
          sale.image_1.recreate_versions!
        end
        if sale.image_2
          sale.image_2.recreate_versions!
        end
      rescue Exception => e
        puts "error #{e.to_s}"
      end
    end

  end

  def down
  end
end
