require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "Validations" do
    subject { described_class.new(dealer_id: 1, expect_delivery_date: "2017-06-30")}
    it "is valid with valid attributes" do
      dealer = Dealer.create(name: 'dealer1')
      subject.dealer_id = dealer.id
      expect(subject).to be_valid
    end
    it "is not valid without valid date" do
      subject.expect_delivery_date = '2017-02-30'
      expect(subject).to_not be_valid
    end
  end

  describe ".show_outstandings" do
  	it "retrieve outstanding orders" do
  	  dealer = Dealer.create(name: 'dealer1')
  	  order = Order.create(dealer_id: dealer.id, expect_delivery_date: "2017-07-30")
  	  expect(described_class.show_outstandings.count).to eq 2
  	end
  end

  describe ".show_fulfilled" do
  	it "retrieve fulfilled orders" do
  	  dealer = Dealer.create(name: 'dealer1')
  	  order = Order.create(dealer_id: dealer.id, expect_delivery_date: "2017-07-30")
  	  expect(described_class.show_fulfilled.count).to eq 0
  	end
  end

  describe ".fulfill" do
  	it "mark order as delivered" do
  	  dealer = Dealer.create(name: 'dealer1')
  	  order = Order.create(dealer: dealer, expect_delivery_date: "2017-07-30")
  	  vehicle = Vehicle.create(vehicle_model_id: 1, vehicle_badge_id: 1,colour: 'red',inventory_quantity: 20)
  	  item = LineItem.create(order: order, vehicle: vehicle, feature: "M", quantity: 2)
  	  expect(described_class.fulfill order.id).to eq 'order delivered!'
  	end
  	it "can not mark order if already delivered" do
   	  dealer = Dealer.create(name: 'dealer1')
  	  order = Order.create(dealer: dealer, expect_delivery_date: "2017-07-30", status: 'fulfilled')
  	  expect(described_class.fulfill order.id).to eq "Couldn't find Order"
  	end
  end

  describe ".create_order_by_dealer" do
    it "create order with valid attributes" do
      dealer = Dealer.create(name: 'dealer1', dealer_unify_id: '1234')
      model = VehicleModel.create(name: 'mustang')
      badge = VehicleBadge.create(name: 'gt fastback')
      vehicle = Vehicle.create(vehicle_model: model, vehicle_badge: badge, colour: 'yellow', inventory_quantity: 30)
      expect(described_class.create_order_by_dealer(dealer,'order_test.csv','2017-06-30')).to eq "order is created!" 
    end
    it "can not create order or line item with invalid badge" do
      dealer = Dealer.create(name: 'dealer1', dealer_unify_id: '1234')
      model = VehicleModel.create(name: 'mustang')
      badge = VehicleBadge.create(name: 'invalid badge')
      vehicle = Vehicle.create(vehicle_model: model, vehicle_badge: badge, colour: 'yellow', inventory_quantity: 30)
      expect(described_class.create_order_by_dealer(dealer,'order_test.csv','2017-06-30')).to eq "vehicle not exist" 
    end
    it "can not create order or line item with invalid quantity" do
      dealer = Dealer.create(name: 'dealer1', dealer_unify_id: '1234')
      model = VehicleModel.create(name: 'mustang')
      badge = VehicleBadge.create(name: 'gt fastback')
      vehicle = Vehicle.create(vehicle_model: model, vehicle_badge: badge, colour: 'yellow', inventory_quantity: 1)
      expect(described_class.create_order_by_dealer(dealer,'order_test.csv','2017-06-30')).to eq "vehicle not exist" 
    end
    it "can not create order or line item with invalid colour" do
      dealer = Dealer.create(name: 'dealer1', dealer_unify_id: '1234')
      model = VehicleModel.create(name: 'mustang')
      badge = VehicleBadge.create(name: 'gt fastback')
      vehicle = Vehicle.create(vehicle_model: model, vehicle_badge: badge, colour: 'red', inventory_quantity: 30)
      expect(described_class.create_order_by_dealer(dealer,'order_test.csv','2017-06-30')).to eq "vehicle not exist" 
    end
  end

end
