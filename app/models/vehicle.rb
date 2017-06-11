class Vehicle < ActiveRecord::Base
  belongs_to :vehicle_model
  belongs_to :vehicle_badge
  has_many :line_items

  validate :colour_valid? 

  COLOUR = ['yellow', 'blue', 'silver', 'red', 'black', 'green', 'pink', 'white', 'grey', 'orange']
  # COLOUR.include? co.downcase

  def self.exist? order_item
    Vehicle.joins(:vehicle_badge, :vehicle_model).where("vehicle_models.name = '#{order_item['model'].downcase}' and vehicle_badges.name = '#{order_item['badge'].downcase}' and vehicles.colour = '#{order_item['colour'].downcase}' and vehicles.inventory_quantity > #{order_item['quantity'].to_i}").present?
  end

  def self.exist_vehicle order_item
  	Vehicle.joins(:vehicle_badge, :vehicle_model).where("vehicle_models.name = '#{order_item['model'].downcase}' and vehicle_badges.name = '#{order_item['badge'].downcase}' and vehicles.colour = '#{order_item['colour'].downcase}'and vehicles.inventory_quantity > #{order_item['quantity'].to_i}").first
  end

  def self.show_full_stock
    Vehicle.includes(:vehicle_badge, :vehicle_model).order(inventory_quantity: :desc)
  end

  private 
  def colour_valid?
  	errors.add(:colour, "colour not exist")	if !COLOUR.include? colour
  end
end
