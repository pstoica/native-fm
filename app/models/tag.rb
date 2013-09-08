class Tag < ActiveRecord::Base
  has_and_belongs_to_many :songs
  has_many :users, through: :preferences
  has_many :preferences

  validates :name, presence: true
end
