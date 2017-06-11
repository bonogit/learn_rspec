class Dealer < ActiveRecord::Base
  has_many :orders

  def self.search_outstanding dealer_name
  	orders = Dealer.find_by!(name:dealer_name).orders.where(status: 'ordered')
  rescue ActiveRecord::RecordNotFound => ex
  	#return string if the dealer is not exist
  	return false
  end
end
