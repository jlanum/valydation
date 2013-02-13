class CreatePagesFromStatic < ActiveRecord::Migration
  def up
    Dir[Rails.root.to_s + "/lib/static_pages/*.html"].each do |page_filename|
      slug = File.basename(page_filename, ".html")
      title = slug.gsub("-"," ")
      content = File.read(page_filename)
      
      page = Page.new
      page.slug = slug
      page.title = title
      page.content = content
      page.save!
    end
  end

  def down
    Dir[Rails.root.to_s + "/lib/static_pages/*.html"].each do |page_filename|
      slug = File.basename(page_filename, ".html")
      Page.find_by_slug(slug).destroy
    end
  end
end
