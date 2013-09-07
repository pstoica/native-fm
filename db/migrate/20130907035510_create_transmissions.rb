class CreateTransmissions < ActiveRecord::Migration
  def change
    create_table :transmissions do |t|
      t.integer :user_id
      t.integer :song_id
      t.boolean :sent

      t.timestamps
    end
  end
end
