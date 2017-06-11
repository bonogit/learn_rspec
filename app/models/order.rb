class MyCustomError < StandardError
  attr_reader :errors
  def initialize(errors)
    @errors = errors
  end
end

class Order < ActiveRecord::Base
  belongs_to :dealer
  has_many :line_items, :dependent => :destroy
  
  validates_format_of :expect_delivery_date, :with => /\d{4}\-\d{2}\-\d{2}/, 
  					  :message => "Date must be in the following format: yyyy-mm-dd"

  def self.create_order_by_file order_info, dealer
    dealer.orders.create(expect_delivery_date: order_info['deliverydate'])
  end

  def self.show_outstandings
  	Order.includes(:dealer).where(status: 'ordered')
  end

  def self.show_fulfilled
  	Order.where(status: 'fulfilled').order(:fulfill_date)
  end

  def self.fulfill order_id
  	# order = Order.find_by(id: order_id, status: 'ordered')
    raise MyCustomError.new('order already delivered!') unless order = Order.find_by(id: order_id, status: 'ordered')
  	#order has two status: orderde(by default) and fulfilled
  	#status will be toggled when order fulfilled
	  ActiveRecord::Base.transaction do
	      order.update_attributes(:status => 'fulfilled', :fulfill_date => DateTime.now)
	      order.line_items.each do |line_item|
	        line_item.vehicle.decrement!(:inventory_quantity, line_item.quantity)
	      end
        return 'order fulfilled succeed!'
    end
  ##TODO catch and return transaction message
  rescue MyCustomError => exception
    return exception.errors
  end
end
