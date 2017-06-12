require 'csv'
module Services
  class OrderProcess

    ##Q1 process CSV passed by filename
	def self.get_order filename
	  #assume files are store on rails root folder
	  filename = File.join Rails.root, filename
	  order_info = CSV.open(filename, 'r', headers: true, 
	    					:header_converters => 
	    					lambda { |h| h.to_s.downcase.gsub(' ', '')}){|row| row.first}
      dealer = Dealer.find_by!(dealer_unify_id: order_info['dealerid'])
      result = Order.create_order_by_dealer dealer, filename, order_info['deliverydate']
      puts result
	rescue ActiveRecord::RecordNotFound => ex
	  puts ex.message
	end
      
	#Q7 mark an order as complete and update vehicle stock level
	def self.fulfill_order order_id
	  result = Order.fulfill order_id
	  puts result
	end
  end
end
