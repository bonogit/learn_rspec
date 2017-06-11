class LineItemError < StandardError
  attr_reader :data
  def initialize(data)
    @data = data
  end
end

class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :vehicle
  validate :feature_valid

  FEATURE = {'M'=> 'metallic', 'S'=> 'seat warmers', 'C'=> 'climate control', 'N'=> 'navigation'}

  def self.create_item new_order, order_item 
  	#check whether vehicle exist
  	if Vehicle.exist? order_item
  	#create line item associated with order&vehicle model
  	  item = new_order.line_items.create!(feature: order_item['features'], quantity: order_item['quantity'], vehicle_id: Vehicle.exist_vehicle(order_item).id)
    else
      # raise ActiveRecord::RecordInvalid.new new_order
      raise Error::LineItemError.new 'vehicle not exist'
    end
  end

  def self.sum_vehicle_sales
  	# result = LineItem.includes(vehicle: [:vehicle_model, :vehicle_badge]).order("vehicle_models.name, vehicle_badges.name, vehicles.colour").group(:vehicle_id)
    result = LineItem.includes(:vehicle).group(:vehicle_id).order("vehicles.vehicle_model_id, vehicles.vehicle_badge_id, vehicles.colour").sum(:quantity)
  end

  private
  #feature valid check activerecord method
  def feature_valid
  	valid_check = feature.split('').map{|ft| FEATURE.keys.include? ft.upcase}
  	errors.add(:feature, "feature not exist") if valid_check.include? false
  end

end

