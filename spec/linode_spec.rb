require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
require 'linode'

describe Linode do
  describe 'as a class' do
    it 'should be able to create a new Linode instance' do
      Linode.should respond_to(:new)
    end
  
    describe 'when creating a new Linode instance' do
      it 'should accept an arguments hash' do
        lambda { Linode.new(:api_key => 'foo') }.should_not raise_error(ArgumentError)
      end
      
      it 'should require an arguments hash' do
        lambda { Linode.new }.should raise_error(ArgumentError)
      end
      
      it 'should not fail if an API key is given' do
        lambda { Linode.new({ :api_key => 'foo' }) }.should_not raise_error(ArgumentError)        
      end
      
      it 'should not fail if a username/password combo is given' do
        lambda { Linode.new({ :username => 'bar', :password => 'baz' }) }.should_not raise_error(ArgumentError)        
      end
      
      it 'should fail if no API key nor username/password combo is given' do
        lambda { Linode.new({}) }.should raise_error(ArgumentError)        
      end
      
      it 'should return a Linode instance' do
        Linode.new(:api_key => 'foo').class.should == Linode
      end
    end
  end
end

describe 'Linode' do  
  before :each do
    @api_key = 'foo'
    @api_url = 'https://fake.linode.com/'
    @username = 'bar'
    @password = 'baz'
    @linode = Linode.new(:api_key => @api_key, :api_url => @api_url)
  end
  
  describe 'when initialized with username and password' do
    before :each do
      @linode = Linode.new(:username => @username, :password => @password, :api_url => @api_url)
    end
    
    it 'should be able to return the username provided at creation time' do
      @linode.username.should == 'bar'      
    end

    it 'should be able to return the password provided at creation time' do
      @linode.password.should == 'baz'
    end

    describe 'when returning the current API URL' do
      it 'should return the API URL provided at creation time if one was provided' do
        @linode.api_url.should == 'https://fake.linode.com/'
      end

      it 'should return the stock linode API URL if none was provided at creation time' do
        @linode = Linode.new(:username => @username, :password => @api_url)
        @linode.api_url.should == 'https://api.linode.com/'      
      end
    end

    it 'should use the user.getapikey remote call to look up the API key associated with the username/password combo specified at creation time' do
      @json = '{"ERRORARRAY":[],"DATA":{"USERNAME":"ogc","API_KEY":"blahblahblah"},"ACTION":"user.getapikey"}'
      HTTParty.expects(:get).with(@api_url, 
        :query => { 
          :api_action => 'user.getapikey', 
          :api_responseFormat => 'json', 
          :username => @username, 
          :password => @password 
        }
      ).returns(@json)
      @linode.api_key
    end

    it 'should return the API key associated with the username/password combo specified at creation time' do
      @linode.stubs(:fetch_api_key).returns(@api_key)
      @linode.api_key.should == @api_key
    end
    
    it 'should fail when looking up the API key if API key remote lookup fails' do
      @linode.stubs(:fetch_api_key).raises
      lambda { @linode.api_key }.should raise_error
    end
    
    it 'should cache API key remote lookups for later use' do
      @linode.stubs(:fetch_api_key).returns(@api_key)
      @linode.api_key
      @linode.stubs(:fetch_api_key).raises
      @linode.api_key.should == @api_key
    end
  end
  
  describe 'when initialized with API key' do
    it 'should return a nil username' do
      @linode.username.should be_nil
    end
    
    it 'should return a nil password' do
      @linode.password.should be_nil
    end
    
    it 'should be able to return the API key provided at creation time' do
      @linode.api_key.should == 'foo'
    end

    describe 'when returning the current API URL' do
      it 'should return the API URL provided at creation time if one was provided' do
        @linode = Linode.new(:api_key => @api_key, :api_url => 'https://fake.linode.com/')
        @linode.api_url.should == 'https://fake.linode.com/'
      end

      it 'should return the stock linode API URL if none was provided at creation time' do
        @linode = Linode.new(:api_key => @api_key)
        @linode.api_url.should == 'https://api.linode.com/'      
      end
    end
  end
  
  it 'should be able to submit a request via the API' do
    @linode.should respond_to(:send_request)
  end
  
  describe 'when submitting a request via the API' do
    before :each do
      @json = %Q!{
      		"ERRORARRAY":[],
      		"ACTION":"test.echo",
      		"DATA":{"FOO":"bar"}
      	}!
      HTTParty.stubs(:get).returns(@json)
      @linode.stubs(:api_url).returns('https://fake.linode.com/')
    end
    
    it 'should allow a request name and a data hash' do
      lambda { @linode.send_request('test.echo', {}) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require a request name and a data hash' do
      lambda { @linode.send_request('test.echo') }.should raise_error(ArgumentError)      
    end
    
    it 'should make a request to the API url' do
      @linode.stubs(:api_url).returns('https://fake.linode.com/')
      HTTParty.expects(:get).with { |path, args|
        path == 'https://fake.linode.com/'
      }.returns(@json)
      @linode.send_request('test.echo', { })
    end
    
    it 'should provide the API key when making its request' do
      HTTParty.expects(:get).with { |path, args|
        args[:query][:api_key] == @api_key
      }.returns(@json)
      @linode.send_request('test.echo', { })      
    end
    
    it 'should set the designated request method as the HTTP API action' do
      HTTParty.expects(:get).with { |path, args|
        args[:query][:api_action] == 'test.echo'
      }.returns(@json)
      @linode.send_request('test.echo', { })            
    end
    
    it 'should set the response format to JSON' do
      HTTParty.expects(:get).with { |path, args|
        args[:query][:api_responseFormat] == 'json'
      }.returns(@json)
      @linode.send_request('test.echo', { })      
    end
    
    it 'should provide the data hash to the HTTP API request' do
      HTTParty.expects(:get).with { |path, args|
        args[:query]['foo'] == 'bar'
      }.returns(@json)
      @linode.send_request('test.echo', { 'foo' => 'bar' })                  
    end
    
    it 'should not allow overriding the API key via the data hash' do
      HTTParty.expects(:get).with { |path, args|
        args[:query][:api_key] == @api_key
      }.returns(@json)
      @linode.send_request('test.echo', { :api_key => 'h4x0r' })                        
    end
    
    it 'should not allow overriding the API action via the data hash' do
      HTTParty.expects(:get).with { |path, args|
        args[:query][:api_action] == 'test.echo'
      }.returns(@json)
      @linode.send_request('test.echo', { :api_action => 'h4x0r' })
    end
    
    it 'should not allow overriding the API response format via the data hash' do
      HTTParty.expects(:get).with { |path, args|
        args[:query][:api_responseFormat] == 'json'
      }.returns(@json)
      @linode.send_request('test.echo', { :api_responseFormat => 'h4x0r' })
    end
    
    it 'should fail when the request submission fails' do
      HTTParty.stubs(:get).returns(%Q!{
      		"ERRORARRAY":["failure"],
      		"ACTION":"test.echo",
      		"DATA":{"foo":"bar"}
      }!)
      lambda { @linode.send_request('test.echo', { :api_action => 'failure' }) }.should raise_error
    end
    
    describe 'when the result is a list of hashes' do
      it 'should return a list of objects with lower-cased methods for the data fields' do
        HTTParty.stubs(:get).returns(%Q!{
        		"ERRORARRAY":[],
        		"ACTION":"test.echo",
        		"DATA":[{"FOO":"bar"},{"BAR":"baz"}]
        }!)
        @linode.send_request('test.echo', {}).first.foo.should == 'bar'
        @linode.send_request('test.echo', {}).last.bar.should == 'baz'
      end
      
      it 'should return a list of objects which do not respond to upper-case URLs for the data fields' do
        HTTParty.stubs(:get).returns(%Q!{
        		"ERRORARRAY":[],
        		"ACTION":"test.echo",
        		"DATA":[{"FOO":"bar"},{"BAR":"baz"}]
        }!)
        @linode.send_request('test.echo', {}).first.should_not respond_to(:FOO)
        @linode.send_request('test.echo', {}).last.should_not respond_to(:BAR)
      end
    end
    
    describe 'when the result is a hash' do
      it 'should return an object with lower-cased methods for the data fields' do
        @linode.send_request('test.echo', {}).foo.should == 'bar'
      end
    
      it 'should return an object which does not respond to upper-case URLs for the data fields' do
        @linode.send_request('test.echo', {}).should_not respond_to(:FOO)
      end
    end
    
    describe 'when the result is neither a list nor a hash' do
      it 'should return the result unchanged' do
        HTTParty.stubs(:get).returns(%Q!{
        		"ERRORARRAY":[],
        		"ACTION":"test.echo",
        		"DATA":"thingie"
        }!)
        @linode.send_request('test.echo', {}).should == "thingie"
      end
    end
  end
  
  it 'should be able to provide access to the Linode Test API' do
    @linode.should respond_to(:test)
  end
  
  describe 'when providing access to the Linode Test API' do
    it 'should allow no arguments' do
      lambda { @linode.test }.should_not raise_error(ArgumentError)
    end
    
    it 'should require no arguments' do
      lambda { @linode.test(:foo) }.should raise_error(ArgumentError)
    end
    
    it 'should return a Linode::Test instance' do
      @linode.test.class.should == Linode::Test
    end
    
    it 'should set the API key on the Linode::Test instance to be our API key' do
      @linode.test.api_key.should == @api_key
    end
    
    it 'should set the API URL on the Linode::Test instance to be our API URL' do
      @linode.test.api_url.should == @api_url
    end
    
    it 'should return the same Linode::Test instance when called again' do
      linode = Linode.new(:api_key => @api_key)
      result = linode.test
      linode.test.should == result
    end
  end

  it 'should be able to provide access to the Linode Avail API' do
    @linode.should respond_to(:avail)
  end
  
  describe 'when providing access to the Linode Avail API' do
    it 'should allow no arguments' do
      lambda { @linode.avail }.should_not raise_error(ArgumentError)
    end
    
    it 'should require no arguments' do
      lambda { @linode.avail(:foo) }.should raise_error(ArgumentError)
    end
    
    it 'should return a Linode::Avail instance' do
      @linode.avail.class.should == Linode::Avail
    end
    
    it 'should set the API key on the Linode::Avail instance to be our API key' do
      @linode.avail.api_key.should == @api_key
    end
    
    it 'should set the API url on the Linode::Avail instance to be our API url' do
      @linode.avail.api_url.should == @api_url
    end
    
    it 'should return the same Linode::Avail instance when called again' do
      linode = Linode.new(:api_key => @api_key)
      result = linode.avail
      linode.avail.should == result
    end
  end
  
  it 'should be able to provide access to the Linode User API' do
    @linode.should respond_to(:user)
  end
  
  describe 'when providing access to the Linode User API' do
    it 'should allow no arguments' do
      lambda { @linode.user }.should_not raise_error(ArgumentError)
    end
    
    it 'should require no arguments' do
      lambda { @linode.user(:foo) }.should raise_error(ArgumentError)
    end
    
    it 'should return a Linode::User instance' do
      @linode.user.class.should == Linode::User
    end
    
    it 'should set the API key on the Linode::User instance to be our API key' do
      @linode.user.api_key.should == @api_key
    end
    
    it 'should set the API url on the Linode::User instance to be our API url' do
      @linode.user.api_url.should == @api_url
    end
    
    it 'should return the same Linode::User instance when called again' do
      linode = Linode.new(:api_key => @api_key)
      result = linode.user
      linode.user.should == result
    end
  end

  it 'should be able to provide access to the Linode Domain API' do
    @linode.should respond_to(:domain)
  end
  
  describe 'when providing access to the Linode Domain API' do
    it 'should allow no arguments' do
      lambda { @linode.domain }.should_not raise_error(ArgumentError)
    end
    
    it 'should require no arguments' do
      lambda { @linode.domain(:foo) }.should raise_error(ArgumentError)
    end
    
    it 'should return a Linode::Domain instance' do
      @linode.domain.class.should == Linode::Domain
    end
    
    it 'should set the API key on the Linode::Domain instance to be our API key' do
      @linode.domain.api_key.should == @api_key
    end
    
    it 'should set the API url on the Linode::Domain instance to be our API url' do
      @linode.domain.api_url.should == @api_url
    end
    
    it 'should return the same Linode::Domain instance when called again' do
      linode = Linode.new(:api_key => @api_key)
      result = linode.domain
      linode.domain.should == result
    end
  end
  
  it 'should be able to provide access to the Linode Linode API' do
    @linode.should respond_to(:linode)
  end
  
  describe 'when providing access to the Linode Linode API' do
    it 'should allow no arguments' do
      lambda { @linode.linode }.should_not raise_error(ArgumentError)
    end
    
    it 'should require no arguments' do
      lambda { @linode.linode(:foo) }.should raise_error(ArgumentError)
    end
    
    it 'should return a Linode::Linode instance' do
      @linode.linode.class.should == Linode::Linode
    end
    
    it 'should set the API key on the Linode::Linode instance to be our API key' do
      @linode.linode.api_key.should == @api_key
    end
    
    it 'should set the API url on the Linode::Linode instance to be our API url' do
      @linode.linode.api_url.should == @api_url
    end
    
    it 'should return the same Linode::Linode instance when called again' do
      linode = Linode.new(:api_key => @api_key)
      result = linode.linode
      linode.linode.should == result
    end
  end
end

