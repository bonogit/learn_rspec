
class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :vehicle
  validate :feature_valid

  FEATURE = {'M'=> 'metallic', 'S'=> 'seat warmers', 'C'=> 'climate control', 'N'=> 'navigation'}

  def self.create_item(new_order, order_item) 
  	if Vehicle.exist? order_item
  	  item = new_order.line_items.create!(feature: order_item['features'], quantity: order_item['quantity'], vehicle_id: Vehicle.exist_vehicle(order_item).id)
    else
      raise Error::LineItemError.new 'vehicle not exist'
    end
  end

  def self.sum_vehicle_sales
    result = LineItem.includes(:vehicle).group(:vehicle_id).order("vehicles.vehicle_model_id, vehicles.vehicle_badge_id, vehicles.colour").sum(:quantity)
  end

  private
  def feature_valid
  	valid_check = feature.split('').map{|ft| FEATURE.keys.include? ft.upcase}
  	errors.add(:feature, "feature not exist") if valid_check.include? false
  end

end

