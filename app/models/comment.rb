class Comment < ActiveRecord::Base
  attr_accessible :user_id, :sale_id, :text
end
