require 'rails_helper'

RSpec.describe Dealer, type: :model do
  subject { described_class.create(name: 'dealer1')}
  describe ".search_outstanding" do
    # it "should return empty when none outstanding order" do
    #   expect(described_class.search_outstanding('dealer1').count).to eq 0
    # end

    it "should return valid outstanding orders" do
      order = subject.orders.create(expect_delivery_date: '2017-06-30')
      expect(described_class.search_outstanding('dealer1').count ).to eq 1 
    end


    it "should return false when dealer not exist" do
      expect(described_class.search_outstanding('dealer0')).to eq false
    end

  end
end
