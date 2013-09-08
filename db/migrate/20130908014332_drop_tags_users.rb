class DropTagsUsers < ActiveRecord::Migration
  def up
    drop_table :tags_users
    create_table :tag_users do |t|
      t.integer :user_id
      t.integer :tag_id

      t.timestamps
    end
  end

  def down
    drop_table :tag_users
    create_join_table :tags, :users
  end
end
