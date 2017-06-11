require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe "Validations" do
    subject { described_class.new(order_id: 1, vehicle_id: 1, feature: 'MSCN', quantity: 3)}
    it "is valid with valid attributes" do
      order = Order.create(dealer_id: 1, expect_delivery_date: "2017-06-30")
      vehicle = Vehicle.create(vehicle_model_id: 1, vehicle_badge_id: 1, colour: 'red', inventory_quantity: 10)
      subject.order_id = order.id
      subject.vehicle_id = vehicle.id
      expect(subject).to be_valid
    end
    
    it "is not valid without valid feature" do
      order = Order.create(dealer_id: 1, expect_delivery_date: "2017-06-30")
      vehicle = Vehicle.create(vehicle_model_id: 1, vehicle_badge_id: 1, colour: 'red', inventory_quantity: 10)
      subject.order_id = order.id
      subject.feature = 'd'
      subject.vehicle_id = vehicle.id
      expect(subject).to_not be_valid
    end
  end

  describe ".sum_vehicle_sales" do
  	it "sum total sale of vehicles by model name and quantity" do
  	  model1 = VehicleModel.create(name: 'mustand')
  	  model2 = VehicleModel.create(name: 'fiesta')
  	  badge1 = VehicleBadge.create(name: 'gt fastback')
  	  badge2 = VehicleBadge.create(name: 'st')
  	  vehicle1 = Vehicle.create(vehicle_model: model1, vehicle_badge: badge1, colour: 'yellow',inventory_quantity: 20)
  	  vehicle2 = Vehicle.create(vehicle_model: model2, vehicle_badge: badge2, colour: 'blue',inventory_quantity: 20)
  	  dealer = Dealer.create(name: 'ringwood')
  	  order1 = dealer.orders.create(expect_delivery_date: "2017-06-30")
  	  item11 = order1.line_items.create(vehicle: vehicle1, feature: 'MSCN', quantity: 2)
  	  item12 = order1.line_items.create(vehicle: vehicle2, feature: 'MSCN', quantity: 4)
	    order2 = Order.create(dealer: dealer, expect_delivery_date: "2017-07-30")
	    item21 = described_class.create(order: order2, vehicle: vehicle2, feature: 'MSCN', quantity: 1)
	    res = {vehicle2.id => 5,vehicle1.id => 2}
  	  expect(described_class.sum_vehicle_sales).to eq res
  	end
  end
end
