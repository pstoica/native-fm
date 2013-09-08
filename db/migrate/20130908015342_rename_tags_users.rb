class RenameTagsUsers < ActiveRecord::Migration
  def change
    rename_table :tag_users, :preferences
  end
end
