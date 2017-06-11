class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :vehicle

  validate :feature_valid? 
  ##TODO add error catch after line_item failed

  FEATURE = {'M'=> 'metallic', 'S'=> 'seat warmers', 'C'=> 'climate control', 'N'=> 'navigation'}

  def self.create_item new_order, order_item 
  	#check whether vehicle exist
  	if Vehicle.exist? order_item
  	#create line item associated with order&vehicle model
  	  new_order.line_items.create(feature: order_item['features'], quantity: order_item['quantity'], vehicle_id: Vehicle.exist_vehicle(order_item).id)
    end
  end

  def self.sum_vehicle_sales
  	result = LineItem.includes(vehicle: [:vehicle_model, :vehicle_badge]).order("vehicle_models.name, vehicle_badges.name, vehicles.colour").group(:vehicle_id)
  	#count result format vehicle_id=>quantity
  	result.count.each do |k,v|
  	  vehicle = Vehicle.find(k)
  	  puts "total sales of #{vehicle.vehicle_model.name} is #{v}"
  	end
  end

  private
  #feature valid check activerecord method
  def feature_valid? 
  	valid_check = feature.split('').map{|ft| FEATURE.keys.include? ft}
  	errors.add(:feature, "feature not exist") if valid_check.include? false
  end

end

