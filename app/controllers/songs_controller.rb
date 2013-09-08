require 'open-uri'

class SongsController < ApplicationController
  respond_to :json

  def data
    url = URI.unescape(params[:url])
    puts url
    @song_data = {}
    @song_data[:url] = url

    # BANDCAMP SCRAPIN'
    if /https?:\/\/.+\.bandcamp.com\/track\/.+/.match(@song_data[:url])
      doc = Nokogiri::HTML(open(@song_data[:url]))

      doc.css('h2.trackTitle').each do |title|
        @song_data[:title] = title.content.strip
      end

      doc.css('[itemprop=byArtist]').each do |artist|
        @song_data[:artist] = artist.content.strip
      end

      @song_data[:tags] = []
      doc.css('.tag').each do |tag|
        tag = Tag.find_or_create_by(name: tag.content.downcase.strip)
        @song_data[:tags] << tag
      end


      # CRAZY SCRAPIN' JAVASCRIPTS
      doc.css('#pgBd script').to_s.scan(/"album_id":(\d+)\,/) do |album_id|
        @song_data[:bandcamp_album_id] = album_id[0]
      end

      doc.css('#pgBd script').to_s.scan(/"track_number":(\d+)\,/) do |track_number|
        @song_data[:bandcamp_track_number] = track_number[0]
      end
    
    # SOUNDCLOUD DATA GATHERING
    elsif /https?:\/\/soundcloud.com\/\w*\/.*/.match(@song_data[:url])
      puts "HI THIS IS THE SOUDNCLOUD CLIB"
      soundcloud = Soundcloud.new(client_id: ENV['SOUNDCLOUD_KEY'])

      resolve_info = soundcloud.get('/resolve', url: @song_data[:url])
      @song_data[:artist] = resolve_info.user.username
      @song_data[:title] = resolve_info.title

      @song_data[:tags] = []
      resolve_info.tag_list.split(" ").each do |tag|
        tag = Tag.find_or_create_by(name: tag.downcase.strip)
        @song_data[:tags] << tag
      end

      # Get embed code
      @song_data[:soundcloud_id] = resolve_info.id

    end

    respond_with(@song_data)


  end
  
  def sent
    @sent = Transmission.includes(:song).where(sender: current_user).order("updated_at DESC").limit(5)

    respond_with(@sent)
  end

  def received
    @received = Transmission.includes(:song).where(receiver: current_user).order("updated_at DESC").limit(10)

    respond_with(@received)
  end

  def search
    @soundcloud = Soundcloud.new(client_id: ENV['SOUNDCLOUD_KEY'])
    respond_with(@soundcloud.get('/tracks', q: params[:q], limit: 10))
  end

end
