class AddIdToTagsUsers < ActiveRecord::Migration
  def change
    change_table :tags_users do |t|
      t.integer :id
    end
  end
end
