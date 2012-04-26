require 'rubygems'
require 'ostruct'
require 'httparty'
require 'json'

class Linode
  attr_reader :username, :password

  def self.has_method(*actions)
    actions.each do |action|
      define_method(action.to_sym) do |*data|
        data = data.shift if data
        data ||= {}
        send_request(Linode.action_path(self.class.name, action), data)
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

  has_namespace :test, :avail, :user, :domain, :linode, :nodebalancer, :stackscript

  @@documentation_category = {}

  def self.documentation_category(category)
    @@documentation_category[class_to_path(name)] = category
  end

  def documentation_categories
    @@documentation_category
  end

  def self.action_path(class_name, action)
    Linode.class_to_path(class_name) + ".#{action}"
  end

  def self.class_to_path(class_name)
    class_name.downcase.sub(/^linode::/, '').gsub(/::/, '.')
  end

  def documentation_path(action)
     hits = action.match(/^(.*)\.[^.]+$/)
    "http://www.linode.com/api/" + @@documentation_category[hits[1]] + '/' + action
  end

  def initialize(args)
    @api_url = args[:api_url] if args[:api_url]

    if args.include?(:api_key)
      @api_key = args[:api_key]
    elsif args.include?(:username) and args.include?(:password)
      @username = args[:username]
      @password = args[:password]
    else
      raise ArgumentError, "Either :api_key, or both :username and :password, are required."
    end
  end

  def api_url
    @api_url || 'https://api.linode.com/'
  end

  def api_key
    @api_key ||= fetch_api_key
  end

  def send_request(action, data)
    data.delete_if {|k,v| [:api_key, :api_action, :api_responseFormat].include?(k) }
    response = post({ :api_key => api_key, :api_action => action, :api_responseFormat => 'json' }.merge(data))
    raise "Errors completing request [#{action}] @ [#{api_url}] with data [#{data.inspect}]:\n#{error_message(response, action)}" if error?(response)
    reformat_response(response)
  end

  protected

  def fetch_api_key
    response = post(:api_action => 'user.getapikey', :api_responseFormat => 'json', :username => username, :password => password)
    raise "Errors completing request [user.getapikey] @ [#{api_url}] for username [#{username}]:\n#{error_message(response, 'user.getapikey')}" if error?(response)
    reformat_response(response).api_key
  end

  def post(data)
    JSON.parse(HTTParty.post(api_url, :body => data))
  end

  def error?(response)
    response and response["ERRORARRAY"] and ! response["ERRORARRAY"].empty?
  end

  def error_message(response, action)
    response["ERRORARRAY"].collect { |err|
      "  - Error \##{err["ERRORCODE"]} - #{err["ERRORMESSAGE"]}.  "+
      "(Please consult #{documentation_path(action)})"
    }.join("\n")
  end

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
    Linode::OpenStruct.new(item)
  end

  # some of our Linode API data results include a 'type' data member.
  # OpenStruct will have problems providing a .type method, so we special-case this.
  #
  class OpenStruct < ::OpenStruct
    def type
      @table[:type]
    end
  end
end

# include all Linode API namespace classes
Dir[File.expand_path(File.dirname(__FILE__) + '/linode/*.rb')].each {|f| require f }
Dir[File.expand_path(File.dirname(__FILE__) + '/linode/**/*.rb')].each {|f| require f }
