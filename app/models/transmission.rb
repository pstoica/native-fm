class Transmission < ActiveRecord::Base
  
  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  belongs_to :song

  validates :song_id, presence: true

  after_save(on: :create) do
    client = Qless::Client.new

    queue = client.queues['matching']
    queue.put(MatchTransmissionJob, transmission_id: self.id)
  end

  def calculate_compatibility(tags)
    return (tags & self.song.tags).size
  end

  def as_json(options={})
    super(:include => [:song])
  end

end
