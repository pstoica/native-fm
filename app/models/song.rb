require 'nokogiri'
require 'open-uri'

class Song < ActiveRecord::Base
  has_and_belongs_to_many :tags

  validates :title, presence: true
  validates :artist, presence: true
  validates :url, presence: true
  validates :location, presence: true
  # validates :lat, presence: true
  # validates :long, presence: true

  before_validation(on: :create) do
    doc = Nokogiri::HTML(open(self.url))

    doc.css('h2.trackTitle').each do |title|
      self.title = title.content.strip
    end

    doc.css('[itemprop=byArtist]').each do |artist|
      self.artist = artist.content.strip
    end

  end
  
end
