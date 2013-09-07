class AddSenderAndReceiverToTransmission < ActiveRecord::Migration
  def change
    change_table :transmissions do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.remove :user_id, :sent
    end
  end
end
