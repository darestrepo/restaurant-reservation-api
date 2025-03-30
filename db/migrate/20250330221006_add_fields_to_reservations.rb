class AddFieldsToReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :reservations, :qr_code_image, :text
    add_column :reservations, :hash_id, :text
    add_column :reservations, :table, :string
    add_column :reservations, :metadata, :json
  end
end
