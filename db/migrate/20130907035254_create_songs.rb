class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :location
      t.string :url
      t.float :lat
      t.float :long
      t.string :note

      t.timestamps
    end
  end
end
