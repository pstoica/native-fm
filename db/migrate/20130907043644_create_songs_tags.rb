class CreateSongsTags < ActiveRecord::Migration
  def change
    create_join_table :songs, :tags
  end
end
