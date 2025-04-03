class AddNoshowStatusToReservations < ActiveRecord::Migration[6.0]
  def up
    # This migration requires a code change in the Reservation model:
    # Change enum status: %i[requested pending booked ended cancelled]
    # to enum status: %i[requested pending booked ended cancelled noshow]
    
    # Safety: No need to change existing DB records since we're adding the enum to the end
    # Just update the model file
    
    # If we wanted to migrate existing data, we'd do:
    # execute <<-SQL
    #   ALTER TYPE reservation_status ADD VALUE 'noshow' AFTER 'cancelled';
    # SQL
    # But since Rails enums are stored as integers, we don't need to modify the schema directly
  end

  def down
    # No schema changes needed, just revert the model code change
    # Change enum status: %i[requested pending booked ended cancelled noshow]
    # to enum status: %i[requested pending booked ended cancelled]
  end
end
