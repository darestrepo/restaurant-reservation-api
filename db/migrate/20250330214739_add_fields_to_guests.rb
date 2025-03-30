class AddFieldsToGuests < ActiveRecord::Migration[6.0]
  def change
    add_column :guests, :notes, :text
    add_column :guests, :allergies, :text
    add_column :guests, :metadata, :json
  end
end
