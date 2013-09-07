class SongsController < ApplicationController

  respond_to :json

  
  def sent
    @sent = Transmission.includes(:song).where(sender: current_user)

    respond_with(@sent)
  end

  def received
    @received = Transmission.includes(:song).where(receiver: current_user)

    respond_with(@received)
  end

end
