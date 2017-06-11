require 'csv'
module Services
	class OrderProcess

	  ##Q1 process CSV passed by filename
	  def self.fetch_order filename
	    #assume files are store on rails root folder
	    filename = File.join Rails.root, filename
	    #fetch first row to create a order
	    order_info = CSV.open(filename, 'r', headers: true, 
	    					  :header_converters => 
	    					  lambda { |h| h.to_s.downcase.gsub(' ', '')}){|row| row.first}
		dealer = Dealer.find_by_dealer_unify_id(order_info['dealerid'])
		#valid check whether dealer exist
		if dealer.blank?
		  result = "order can not be processed - dealer not exist"
		else
	      new_order = Order.create_order_by_file order_info, dealer
	      result = new_order.valid? ? "order is created!" : "order can not be processed - #{new_order.errors.messages[:delivery_date].first}"
		  #fetch order info, create line items
        ###TODO order is not roll back when lineitem failed
        ###line item not roll back when one in the group failed
        ###line item not roll back when quantity validation failed
		  if new_order.valid?
		  	LineItem.transaction do
			  CSV.foreach(filename, headers: true,
			  			  :header_converters => lambda { |h| h.to_s.downcase.gsub(' ', '')}) do |row| 
			    LineItem.create_item new_order, row 
			  end	
			end
		  end 
		end
		print result
	  end

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
        case outstanding_orders
        when false
        #show error message if dealer not found
  	  	  puts 'dealer not exist'
  	  	when []
  	  	#show none exist msg when dealer not having outstanding 
	  	  puts "#{dealer_name} has no outstading order"
	  	else
	  	#outstanding orders 
  	      outstanding_orders.each {|order| puts "#{dealer_name} - Ordered #{order.expect_delivery_date.strftime("%d/%m/%Y")}"}
        end
	  end

	  ##Q4 show historic total quantities of each vehicle
	  def self.show_total_quantities
	  	total_quantities = LineItem.sum_vehicle_sales
	  end

	  ##Q5 show stock levels of each vehicle order by stock level
	  def self.show_stock
	    Vehicle.show_full_stock.each{|vehicle| puts "Ford #{vehicle.vehicle_model.name} #{vehicle.vehicle_badge.name} #{vehicle.colour} stock: #{vehicle.inventory_quantity}"}	
	  end

	  ##Q6 show history of completed orders by date
	  def self.show_fulfilled_orders
	    Order.show_fulfilled.each{|order| puts "order #{order.id} is delivered at #{order.fulfill_date.strftime('%d/%m/%Y')}"}
	  end

	  #Q7 mark an order as complete and update vehicle stock level
	  def self.fulfill_order order_id
	  	Order.fulfill order_id
	  	##TODO properly log failed action
	  end

	end
end
