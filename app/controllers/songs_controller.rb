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

  def search
    @soundcloud = Soundcloud.new(client_id: ENV['SOUNDCLOUD_KEY'])
    respond_with(@soundcloud.get('/tracks', q: params[:q]))
  end

end
