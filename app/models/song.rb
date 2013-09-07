class Song < ActiveRecord::Base
  has_and_belongs_to_many :tags

  validates :title, presence: true
  validates :artist, presence: true
  validates :url, presence: true
  validates :location, presence: true
  validates :lat, presence: true
  validates :long, presence: true

  before_validation(on: :create) do
    doc = Nokogiri::HTML(open(this.url))

    doc.css('.trackTitle').each do |title|
      self.title = title.content
    end
  end
  
end
