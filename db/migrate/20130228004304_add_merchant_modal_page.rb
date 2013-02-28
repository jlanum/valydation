class AddMerchantModalPage < ActiveRecord::Migration
  def up
    Page.load_unloaded    
  end

  def down
    if page = Page.where(:slug => "merchant-modal").first
      page.destroy    
    end
  end
end
