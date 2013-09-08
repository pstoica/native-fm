class TransmissionsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    @transmission = Transmission.new

    # Just supply a url in song params, before validation, the song
    # data will be automatically scraped based on the URL. If the
    # song 
    
    @song = Song.find_or_initialize_by(url: song_params[:url])

    # Shit is fresh
    if !@song.location
      @song.location = song_params[:location]
      if song_params[:tags].nil? then @song.tags = [] else @song.tags = song_params[:tags] end
    end
    @song.save

    @transmission.song = @song
    @transmission.sender = current_user
    @transmission.save
    
    respond_with(@transmission)
  end

  def show
  end


  private
    def song_params
      params.require(:song).permit(:url, :location, :tags)
    end
end
