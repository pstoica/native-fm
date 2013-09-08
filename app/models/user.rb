class User < ActiveRecord::Base
  validates_presence_of :name

  has_many :sent, class_name: "Transmission", foreign_key: "sender_id"
  has_many :received, class_name: "Transmission", foreign_key: "receiver_id"
  has_many :preferences, dependent: :destroy
  has_many :tags, through: :preferences

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
         user.email = auth['info']['email'] || ""
      end
    end
  end

  def as_json(options={})
    super(:include => [:tags])
  end
end
