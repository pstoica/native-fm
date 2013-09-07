class MakeSongIdStrings < ActiveRecord::Migration
  def up
    remove_column :songs, :bandcamp_track_number
    remove_column :songs, :bandcamp_album_id
    remove_column :songs, :soundcloud_id
    
    add_column :songs, :bandcamp_track_number, :string
    add_column :songs, :bandcamp_album_id, :string
    add_column :songs, :soundcloud_id, :string
  end

  def down
    remove_column :songs, :bandcamp_track_number
    remove_column :songs, :bandcamp_album_id
    remove_column :songs, :soundcloud_id

    add_column :songs, :bandcamp_track_number, :integer
    add_column :songs, :bandcamp_album_id, :integer
    add_column :songs, :soundcloud_id, :integer
  end
end
