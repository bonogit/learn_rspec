class CreateVehicleModels < ActiveRecord::Migration
  def change
    create_table :vehicle_models do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
