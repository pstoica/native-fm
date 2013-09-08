class MatchTransmission < Struct.new(:transmission)

  def perform

    if transmission.receiver
      return
    end

    sender = transmission.sender

    open_transmissions = Transmission.where(receiver_id: nil).where.not(sender_id: sender)

    if open_transmissions.empty? 
      raise ArgumentError, "No open transmissions"
    end

    transmission.attempts += 1
    max_transmission = open_transmissions.max_by do |t|
      t.calculate_compatibility(sender.tags)
    end

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


  def failure(job)
    # puts job
    # Delayed::Job.enqueue MatchTransmission.new(job.transmission), queue: 'matching'
  end

  def max_attempts
    return 25
  end

end
