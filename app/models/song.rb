class Song < ActiveRecord::Base
  has_many :tags

  validates :title, presence: true
  validates :artist, presence: true
  validates :url, presence: true
  
end
