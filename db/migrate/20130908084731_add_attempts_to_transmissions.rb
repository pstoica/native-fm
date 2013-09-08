class AddAttemptsToTransmissions < ActiveRecord::Migration
  def change
    add_column :transmissions, :attempts, :integer, default: 0
  end
end
