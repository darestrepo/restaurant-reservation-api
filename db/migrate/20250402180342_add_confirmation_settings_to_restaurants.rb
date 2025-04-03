class AddConfirmationSettingsToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :send_confirmation, :boolean, default: false
    add_column :restaurants, :send_confirmation_before, :integer, default: 24
  end
end
