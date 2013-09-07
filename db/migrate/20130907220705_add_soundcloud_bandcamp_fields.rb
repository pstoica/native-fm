class AddSoundcloudBandcampFields < ActiveRecord::Migration
  def change
    change_table :songs do |t|
      t.integer :bandcamp_track_number
      t.integer :bandcamp_album_id
      t.integer :soundcloud_id
    end
  end
end
