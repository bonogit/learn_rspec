class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.references :vehicle_model, index: true, foreign_key: true
      t.references :vehicle_badge, index: true, foreign_key: true
      t.string :colour
      t.integer :inventory_quantity

      t.timestamps null: false
    end
  end
end
