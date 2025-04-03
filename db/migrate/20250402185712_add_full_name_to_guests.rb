class AddFullNameToGuests < ActiveRecord::Migration[6.0]
  def change
    add_column :guests, :full_name, :string
    
    # Make first_name and last_name optional by allowing null values
    change_column_null :guests, :first_name, true
    change_column_null :guests, :last_name, true
  end
end
