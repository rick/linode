class Linode
  attr_reader :api_key
  
  def initialize(args)
    raise ArgumentError, ":api_key is required" unless args[:api_key]
    @api_key = args[:api_key]
  end
  
  def test
    @test ||= Test.new(:api_key => api_key)
  end
end

class Linode::Test < Linode
end