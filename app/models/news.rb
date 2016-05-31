class News < ActiveRecord::Base

  mount_uploader :image, ImageUploader

  has_many :photos
  has_many :comments

  belongs_to :site
  belongs_to :city
  belongs_to :region

  scope :with_top_news, -> {order('top_news desc')}
  scope :top_news_only, -> {where(top_news: true)}
  scope :by_date, -> {order('date desc')}


  def self.last_date
    self.order('date desc').first.date rescue Date.new(2009,11,26).to_time
  end
end
