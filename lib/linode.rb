class Linode
  attr_reader :api_key
  
  def initialize(args)
    raise ArgumentError, ":api_key is required" unless args[:api_key]
    @api_key = args[:api_key]
  end
  
  def test
    @test ||= Linode::Test.new(:api_key => api_key)
  end

  def avail
    @avail ||= Linode::Avail.new(:api_key => api_key)
  end
end

# include all Linode API namespace classes
Dir[File.expand_path(File.dirname(__FILE__) + '/linode/*.rb')].each {|f| puts f; require f }