class Comment < ActiveRecord::Base
  validates_length_of :title, :within => 2..255
  validates_length_of :content, :within => 2..500
end
