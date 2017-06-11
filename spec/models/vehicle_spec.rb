require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe ".exist?" do
  	it "vehicle should exist" do
  	  #create vehicle/model/badge
  	  model = VehicleModel.create(name: 'fiesta')
  	  badge = VehicleBadge.create(name: 'st')
  	  Vehicle.create(vehicle_model_id: model.id, vehicle_badge_id: badge.id, colour: 'red', inventory_quantity: 10)
  	  #fake an order to search if vehicle exist
  	  order_item = {'dealid'=>'2431','deliverydate'=>'2017-06-22','model'=>'fiesta','badge'=>'st','colour'=>'red','features'=>'S','quantity'=>2}
  	  expect(described_class.exist? order_item).to eq true
    end
  end

  describe "Validations" do
    subject { described_class.create(vehicle_model_id: 1, vehicle_badge_id: 1, colour: 'red', inventory_quantity: 10)}
    it "is valid with valid attributes" do
  	  subject.vehicle_model_id = VehicleModel.create(name: 'fiesta').id
      subject.vehicle_badge_id = VehicleBadge.create(name: 'st').id
  	  expect(subject).to be_valid
    end

    it "is not valid with invalid colour attributes" do
      subject.vehicle_model_id = VehicleModel.create(name: 'fiesta').id
  	  subject.vehicle_badge_id = VehicleBadge.create(name: 'st').id
  	  subject.colour = 'beige'
  	  expect(subject).to_not be_valid
    end
  end
end
