require 'nokogiri'
require 'open-uri'

class Song < ActiveRecord::Base
  has_and_belongs_to_many :tags

  geocoded_by :location, latitude: :lat, longitude: :long

  validates :title, presence: true
  validates :artist, presence: true
  validates :url, presence: true, uniqueness: true
  validates :location, presence: true

  before_validation(on: :create) do
    
    # Find out what url we're working with,
    # process accordingly.


    # BANDCAMP SCRAPIN'
    if /https?:\/\/.+\.bandcamp.com\/track\/.+/.match(self.url)
      doc = Nokogiri::HTML(open(self.url))

      doc.css('h2.trackTitle').each do |title|
        self.title = title.content.strip
      end

      doc.css('[itemprop=byArtist]').each do |artist|
        self.artist = artist.content.strip
      end

      doc.css('.tag').each do |tag|
        tag = Tag.find_or_create_by(name: tag.content.downcase.strip)
        self.tags << tag
      end


      # CRAZY SCRAPIN' JAVASCRIPTS
      doc.css('#pgBd script').to_s.scan(/"album_id":(\d+)\,/) do |album_id|
        self.bandcamp_album_id = album_id[0]
      end

      doc.css('#pgBd script').to_s.scan(/"track_number":(\d+)\,/) do |track_number|
        self.bandcamp_track_number = track_number[0]
      end
    
    # SOUNDCLOUD DATA GATHERING
    elsif /https?:\/\/soundcloud.com\/\w*\/.*/.match(self.url)
      puts "HI THIS IS THE SOUDNCLOUD CLIB"
      soundcloud = Soundcloud.new(client_id: ENV['SOUNDCLOUD_KEY'])

      resolve_info = soundcloud.get('/resolve', url: self.url)
      self.artist = resolve_info.user.username
      self.title = resolve_info.title

      tags = []
      resolve_info.tag_list.split(" ").each do |tag|
        tag = Tag.find_or_create_by(name: tag.content.downcase.strip)
        tags << tag
      end
      self.tags = tags

      # Get embed code
      self.soundcloud_id = resolve_info.id

    end



  end
  
  after_validation :geocode
  
end
