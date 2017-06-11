module Error
  class LineItemError < StandardError
	attr_reader :data
	def initialize(data)
	  @data = data
	end
  end
end