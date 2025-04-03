class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :restaurant, null: true, foreign_key: true
    add_column :users, :active, :boolean, default: true
  end
end
