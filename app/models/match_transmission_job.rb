class MatchTransmissionJob
  
  def self.default_job_options(data)
    { retries: 25 }
  end

  def self.perform(job)

    puts job.data
    # Lookup the transmission to be matched.
    transmission = Transmission.find(job.data.transmission_id)

    puts transmission

    # If it's been matched already, get outta here.
    if transmission.receiver
      return
    end

    puts "this is ok"
    # Otherwise find other open transmissions sent by other people.
    sender = transmission.sender

    open_transmissions = Transmission.where(receiver_id: nil).where.not(sender_id: sender)

    if open_transmissions.empty? 
      raise ArgumentError, "No open transmissions"
    end

    # See if there are some matching tags first, if not, requeue. If it's been tried a lot, just use it anyway.
    max_transmission = open_transmissions.max_by do |t|
      t.calculate_compatibility(sender.tags)
    end

    transmission.attempts += 1

    if max_transmission.calculate_compatibility(sender.tags) == 0 and transmission.attempts < 4
      transmission.save
      raise ArgumentError, "No good match"
    else
      transmission.receiver = max_transmission.sender
      transmission.save

      max_transmission.receiver = transmission.sender
      max_transmission.save
    end
  end

end