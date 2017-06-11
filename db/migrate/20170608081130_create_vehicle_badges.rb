class CreateVehicleBadges < ActiveRecord::Migration
  def change
    create_table :vehicle_badges do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
