class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
  validates :user_id, uniqueness: { scope: :tag_id }

  def as_json(options={})
    super(:include => [:tag])
  end
end
