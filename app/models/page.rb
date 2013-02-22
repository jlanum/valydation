class Page < ActiveRecord::Base
  # attr_accessible :title, :body

  def self.load_unloaded
    Dir[Rails.root.to_s + "/lib/static_pages/*.html"].each do |page_filename|
      slug = File.basename(page_filename, ".html")
      title = slug.gsub("-"," ")
      content = File.read(page_filename)
      
      unless Page.find_by_slug(slug)
        page = Page.new
        page.slug = slug
        page.title = title
        page.content = content
        page.save!
      end
    end    
  end

end
