module Services
  class VehicleReport
    ##Q2 show outstanding orders for all dealers by delivery date order
    def self.show_all_outstanding
    	all_outstanding_orders = Order.show_outstandings
    	if all_outstanding_orders.blank?
    	  puts 'None Outstanding orders'
    	else
    	  all_outstanding_orders.each {|order| puts "#{order.dealer.name} - Ordered #{order.expect_delivery_date.strftime("%d/%m/%Y")}"}
    	end	
    end

    ##Q3 show outstanding orders for single dealer by dealer name
    def self.show_dealer_outstanding dealer_name
      outstanding_orders = Dealer.search_outstanding dealer_name
      if outstanding_orders.blank? 
    	  puts "#{dealer_name} has no outstading order"
    	else
        outstanding_orders.each {|order| puts "#{dealer_name} - Ordered #{order.expect_delivery_date.strftime("%d/%m/%Y")}"}
      end
    end

    ##Q4 show historic total quantities of each vehicle
    def self.show_total_quantities
    	total_sales = LineItem.sum_vehicle_sales
      #count result format vehicle_id=>quantity
      total_sales.each do |k,v|
        vehicle = Vehicle.find(k)
        puts "total sales of #{vehicle.vehicle_model.name} #{vehicle.vehicle_badge.name} #{vehicle.colour} is #{v}"
      end
    end

    ##Q5 show stock levels of each vehicle order by stock level
    def self.show_stock
      Vehicle.show_full_stock.each{|vehicle| puts "Ford #{vehicle.vehicle_model.name} #{vehicle.vehicle_badge.name} #{vehicle.colour} stock: #{vehicle.inventory_quantity}"}	
    end

    ##Q6 show history of completed orders by date
    def self.show_fulfilled_orders
      Order.show_fulfilled.each{|order| puts "order #{order.id} is delivered at #{order.fulfill_date.strftime('%d/%m/%Y')}"}
    end
  end
end