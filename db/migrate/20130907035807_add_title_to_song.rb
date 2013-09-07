class AddTitleToSong < ActiveRecord::Migration
  def change
    change_table :songs do |t|
      t.string :title
    end
  end
end
