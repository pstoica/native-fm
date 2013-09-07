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

    random_transmission = open_transmissions[rand(open_transmissions.length)]

    transmission.receiver = random_transmission.sender
    transmission.save

    random_transmission.receiver = transmission.sender
    random_transmission.save
  end


  def failure(job)
    # puts job
    # Delayed::Job.enqueue MatchTransmission.new(job.transmission), queue: 'matching'
  end

  def max_attempts
    return 25
  end

end