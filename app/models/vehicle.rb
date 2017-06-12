class Vehicle < ActiveRecord::Base
  belongs_to :vehicle_model
  belongs_to :vehicle_badge
  has_many :line_items

  validates_inclusion_of :colour, in: ['yellow', 'blue', 'silver', 'red', 'black', 'green', 'pink', 'white', 'grey', 'orange']
  validates_numericality_of :inventory_quantity, :greater_than_or_equal_to => 0

  def self.exist?(order_item)
    Vehicle.joins(:vehicle_badge, :vehicle_model).where("vehicle_models.name = '#{order_item['model'].downcase}' and vehicle_badges.name = '#{order_item['badge'].downcase}' and vehicles.colour = '#{order_item['colour'].downcase}' and vehicles.inventory_quantity > #{order_item['quantity'].to_i}").present?
  end

  def self.exist_vehicle(order_item)
  	Vehicle.joins(:vehicle_badge, :vehicle_model).where("vehicle_models.name = '#{order_item['model'].downcase}' and vehicle_badges.name = '#{order_item['badge'].downcase}' and vehicles.colour = '#{order_item['colour'].downcase}'and vehicles.inventory_quantity > #{order_item['quantity'].to_i}").first
  end

  def self.show_full_stock
    Vehicle.includes(:vehicle_badge, :vehicle_model).order(inventory_quantity: :desc)
  end

end
