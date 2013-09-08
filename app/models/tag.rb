class Tag < ActiveRecord::Base
  has_and_belongs_to_many :songs
  has_many :users, through: :tags_users

  validates :name, presence: true
end
