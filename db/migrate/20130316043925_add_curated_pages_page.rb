class AddCuratedPagesPage < ActiveRecord::Migration
  def up
    Page.load_unloaded
  end

  def down
    Page.find_by_slug('curated-landing').destroy
    Page.find_by_slug('custom-css').destroy
  end
end
