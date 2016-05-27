class Region < ActiveRecord::Base
  has_many :cities
  has_many :news
end
