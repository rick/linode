class Linode
  attr_reader :api_key
  
  def initialize(args)
    raise ArgumentError, ":api_key is required" unless args[:api_key]
    @api_key = args[:api_key]
  end
end