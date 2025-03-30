class AddFieldsToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :channel_phone_id, :text
    add_column :restaurants, :channel_token, :text
    add_column :restaurants, :channel_number, :text
    add_column :restaurants, :tenant_id, :text
    add_column :restaurants, :reservations_contacts, :json
    add_column :restaurants, :metadata, :json
  end
end
