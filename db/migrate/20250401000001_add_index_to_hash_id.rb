class AddIndexToHashId < ActiveRecord::Migration[6.0]
  def change
    add_index :reservations, :hash_id, unique: true
  end
end 