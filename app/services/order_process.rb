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
      
   #    def self.process_order filename
	  #   #assume files are store on rails root folder
	  #   filename = File.join Rails.root, filename
	  #   i = 0
	  #   CSV.foreach(filename, headers: true,
			#   			  :header_converters => lambda { |h| h.to_s.downcase.gsub(' ', '')}) do |row| 
	  #   #row 1 create
	  #   if i == 0 
	  #   end	
	  # end


	  #Q7 mark an order as complete and update vehicle stock level
	  def self.fulfill_order order_id
	  	result = Order.fulfill order_id
	  	puts result
	  	##TODO properly log failed action
	  end

	end
end
