class Transmission < ActiveRecord::Base
  
  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  belongs_to :song

  after_save(on: :create) do
    Delayed::Job.enqueue MatchTransmission.new(self), queue: 'matching'
  end

  def calculate_compatibility(tags)
    return (tags & self.song.tags).size
  end

  def as_json(options={})
    super(:include => [:song])
  end

end
