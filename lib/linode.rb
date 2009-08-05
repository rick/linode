require 'rubygems'
require 'httparty'

class Linode
  attr_reader :api_key
  
  def initialize(args)
    raise ArgumentError, ":api_key is required" unless args[:api_key]
    @api_key = args[:api_key]
    @api_url = args[:api_url] if args[:api_url]
  end
  
  def send_request(action, data)
    data.delete_if {|k,v| [:api_key, :api_action].include?(k) }
    result = Crack::JSON.parse(HTTParty.get(api_url, :query => { :api_key => api_key, :api_action => action }.merge(data)))
    raise "Error completing request [#{action}] with data [#{data.inspect}]: #{result["ERRORARRAY"].join(" / ")}" if result and result["ERRORARRAY"] and ! result["ERRORARRAY"].empty?
    reformat_response(result)
  end
  
  def test
    @test ||= Linode::Test.new(:api_key => api_key)
  end

  def avail
    @avail ||= Linode::Avail.new(:api_key => api_key)
  end
  
  def api_url
    @api_url || 'https://api.linode.com/'
  end
  
  protected
  
  def reformat_response(response)
    result = response['DATA']
    result.keys.each do |k| 
      result[k.downcase] = result[k]
      result.delete(k) if k != k.downcase
    end
    OpenStruct.new(result)
  end
end

# include all Linode API namespace classes
Dir[File.expand_path(File.dirname(__FILE__) + '/linode/*.rb')].each {|f| puts f; require f }