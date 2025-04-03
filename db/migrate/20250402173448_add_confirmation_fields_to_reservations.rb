class AddConfirmationFieldsToReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :reservations, :confirmation_request, :boolean, default: false
    add_column :reservations, :confirmation_request_date, :datetime
  end
end
