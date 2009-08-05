require 'rubygems'
require 'ostruct'
require 'httparty'

class Linode
  attr_reader :api_key
  
  def self.has_method(*actions)
    actions.each do |action|
      define_method(action.to_sym) do |*data|
        data = data.shift if data
        data ||= {}
        send_request(self.class.name.downcase.sub(/^linode::/, '').gsub(/::/, '.') + ".#{action}", data)
      end
    end
  end
  
  def self.has_namespace(*namespaces)
    namespaces.each do |namespace|
      define_method(namespace.to_sym) do ||
        lookup = instance_variable_get("@#{namespace}")
        return lookup if lookup
        subclass = self.class.const_get(namespace.to_s.capitalize).new(:api_key => api_key, :api_url => api_url)
        instance_variable_set("@#{namespace}", subclass)
        subclass
      end
    end
  end
  
  has_namespace :test, :avail, :user, :domain
  
  def initialize(args)
    raise ArgumentError, ":api_key is required" unless args[:api_key]
    @api_key = args[:api_key]
    @api_url = args[:api_url] if args[:api_url]
  end
    
  def api_url
    @api_url || 'https://api.linode.com/'
  end

  def send_request(action, data)
    data.delete_if {|k,v| [:api_key, :api_action, :api_responseFormat].include?(k) }
    result = Crack::JSON.parse(HTTParty.get(api_url, :query => { :api_key => api_key, :api_action => action, :api_responseFormat => 'json' }.merge(data)))
    raise "Error completing request [#{action}] @ [#{api_url}] with data [#{data.inspect}]: #{result["ERRORARRAY"].join(" / ")}" if result and result["ERRORARRAY"] and ! result["ERRORARRAY"].empty?
    reformat_response(result)
  end
 
  protected
  
  def reformat_response(response)
    result = response['DATA']
    return result.collect {|item| convert_item(item) } if result.class == Array
    return result unless result.respond_to?(:keys)
    convert_item(result)
  end
  
  def convert_item(item)
    item.keys.each do |k| 
      item[k.downcase] = item[k]
      item.delete(k) if k != k.downcase
    end
    ::OpenStruct.new(item)
  end
end

# include all Linode API namespace classes
Dir[File.expand_path(File.dirname(__FILE__) + '/linode/*.rb')].each {|f| require f }
Dir[File.expand_path(File.dirname(__FILE__) + '/linode/**/*.rb')].each {|f| require f }