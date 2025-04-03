class AddConfirmationTextFieldsToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :confirmation_header_text, :text, default: "Please confirm your reservation"
    add_column :restaurants, :confirmation_body_text, :text, default: "We're looking forward to seeing you. Please confirm your reservation by replying YES."
  end
end
