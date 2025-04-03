class CreateTables < ActiveRecord::Migration[6.0]
  def change
    create_table :tables do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :name
      t.string :section
      t.integer :capacity
      t.integer :position_x
      t.integer :position_y
      t.json :metadata

      t.timestamps
    end
  end
end
