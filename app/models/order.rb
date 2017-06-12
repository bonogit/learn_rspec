require 'csv'
class Order < ActiveRecord::Base
  belongs_to :dealer
  has_many :line_items, :dependent => :destroy
  
  validates :expect_delivery_date, date: true
  
  def self.create_order_by_dealer(dealer, filename, delivery_date)
    ActiveRecord::Base.transaction do
      new_order = dealer.orders.create!(expect_delivery_date: delivery_date)
      CSV.foreach(filename, headers: true,
                :header_converters => lambda { |h| h.to_s.downcase.gsub(' ', '')}) do |row| 
          LineItem.create_item new_order, row
      end
      return "order is created!" 
    end
  rescue ActiveRecord::RecordNotFound,ActiveRecord::RecordInvalid,ActiveRecord::StatementInvalid, Error::LineItemError => exception
    return exception.message
  end

  def self.show_outstandings
  	Order.includes(:dealer).where(status: 'ordered')
  end

  def self.show_fulfilled
  	Order.where(status: 'fulfilled').order(:fulfill_date)
  end

  def self.fulfill(order_id)
  #order has two status: ordered(by default) and fulfilled
    ActiveRecord::Base.transaction do
      order = Order.find_by!(id: order_id, status: 'ordered')
      order.update_attributes(:status => 'fulfilled', :fulfill_date => DateTime.now)
      order.line_items.each do |line_item|
       line_item.vehicle.decrement!(:inventory_quantity, line_item.quantity)
      end
      return 'order delivered!'
    end
  rescue ActiveRecord::RecordNotFound,ActiveRecord::RecordInvalid,ActiveRecord::StatementInvalid => exception
    return exception.message
  end
end
