require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
require 'linode'

describe Linode do
  describe 'as a class' do
    it 'should be able to create a new Linode instance' do
      Linode.should respond_to(:new)
    end

    describe 'when creating a new Linode instance' do
      it 'should accept an arguments hash' do
        lambda { Linode.new(:api_key => 'foo') }.should_not raise_error
      end

      it 'should require an arguments hash' do
        lambda { Linode.new }.should raise_error(ArgumentError)
      end

      it 'should not fail if an API key is given' do
        lambda { Linode.new({ :api_key => 'foo' }) }.should_not raise_error
      end

      it 'should not fail if a username/password combo is given' do
        lambda { Linode.new({ :username => 'bar', :password => 'baz' }) }.should_not raise_error
      end

      it 'should fail if no API key nor username/password combo is given' do
        lambda { Linode.new({}) }.should raise_error(ArgumentError)
      end

      it 'should allow providing a logger' do
        linode = Linode.new(:api_key => 'foo', :logger => 'bar')
        linode.logger.should == 'bar'
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
      @json.stubs(:parsed_response).returns(JSON.parse(@json))

      HTTParty.expects(:post).with(@api_url,
        :body => {
          :api_action => 'user.getapikey',
          :api_responseFormat => 'json',
          :username => @username,
          :password => @password
        },
        :headers => {
          'User-Agent' => "linode/#{Linode::VERSION} ruby/#{RUBY_VERSION}"
        }
      ).returns(@json)
      @linode.api_key
    end

    it 'should return the API key associated with the username/password combo specified at creation time' do
      @linode.stubs(:fetch_api_key).returns(@api_key)
      @linode.api_key.should == @api_key
    end

    it 'should request the API key only when accessed' do
      @linode = Linode.new(:username => @username, :password => @api_url)
      @linode.stubs(:fetch_api_key).returns 'foo'
      @linode.api_key.should == 'foo'
    end

    it 'should allow assigning a label to an API key' do
      @json = '{"ERRORARRAY":[],"DATA":{"USERNAME":"ogc","API_KEY":"blahblahblah"},"ACTION":"user.getapikey"}'
      @json.stubs(:parsed_response).returns(JSON.parse(@json))

      HTTParty.expects(:post).with(@api_url,
        :body => {
          :api_action => 'user.getapikey',
          :api_responseFormat => 'json',
          :username => @username,
          :password => @password,
          :label => 'foobar'
        },
        :headers => {
          'User-Agent' => "linode/#{Linode::VERSION} ruby/#{RUBY_VERSION}"
        }
      ).returns(@json)

      @linode.fetch_api_key(:label => 'foobar')
    end

    it 'should allow assigning expires when requesting an API key' do
      @json = '{"ERRORARRAY":[],"DATA":{"USERNAME":"ogc","API_KEY":"blahblahblah"},"ACTION":"user.getapikey"}'
      @json.stubs(:parsed_response).returns(JSON.parse(@json))

      HTTParty.expects(:post).with(@api_url,
        :body => {
          :api_action => 'user.getapikey',
          :api_responseFormat => 'json',
          :username => @username,
          :password => @password,
          :expires => 5
        },
        :headers => {
          'User-Agent' => "linode/#{Linode::VERSION} ruby/#{RUBY_VERSION}"
        }
      ).returns(@json)

      @linode.fetch_api_key(:expires => 5)
    end

    it 'should allow use 0 to signify a non-expiring api-key when passed a nil :expires' do
      @json = '{"ERRORARRAY":[],"DATA":{"USERNAME":"ogc","API_KEY":"blahblahblah"},"ACTION":"user.getapikey"}'
      @json.stubs(:parsed_response).returns(JSON.parse(@json))

      HTTParty.expects(:post).with(@api_url,
        :body => {
          :api_action => 'user.getapikey',
          :api_responseFormat => 'json',
          :username => @username,
          :password => @password,
          :expires => 0
        },
        :headers => {
          'User-Agent' => "linode/#{Linode::VERSION} ruby/#{RUBY_VERSION}"
        }
      ).returns(@json)

      @linode.fetch_api_key(:expires => nil)
    end

    it 'should not specify expires when :expires was not specified' do
      @json = '{"ERRORARRAY":[],"DATA":{"USERNAME":"ogc","API_KEY":"blahblahblah"},"ACTION":"user.getapikey"}'
      @json.stubs(:parsed_response).returns(JSON.parse(@json))

      HTTParty.expects(:post).with(@api_url,
        :body => {
          :api_action => 'user.getapikey',
          :api_responseFormat => 'json',
          :username => @username,
          :password => @password
        },
        :headers => {
          'User-Agent' => "linode/#{Linode::VERSION} ruby/#{RUBY_VERSION}"
        }
      ).returns(@json)

      @linode.fetch_api_key
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
      @json.stubs(:parsed_response).returns(JSON.parse(@json))
      HTTParty.stubs(:post).returns(@json)
      @linode.stubs(:api_url).returns('https://fake.linode.com/')
    end

    it 'should allow a request name and a data hash' do
      lambda { @linode.send_request('test.echo', {}) }.should_not raise_error
    end

    it 'should require a request name and a data hash' do
      lambda { @linode.send_request('test.echo') }.should raise_error(ArgumentError)
    end

    it 'should make a request to the API url' do
      @linode.stubs(:api_url).returns('https://fake.linode.com/')
      HTTParty.expects(:post).with { |path, args|
        path == 'https://fake.linode.com/'
      }.returns(@json)
      @linode.send_request('test.echo', { })
    end

    it 'should provide the API key when making its request' do
      HTTParty.expects(:post).with { |path, args|
        args[:body][:api_key] == @api_key
      }.returns(@json)
      @linode.send_request('test.echo', { })
    end

    it 'should include a custom User-Agent when making its request' do
      HTTParty.expects(:post).with { |path, args|
        args[:headers]['User-Agent'] == "linode/#{Linode::VERSION} ruby/#{RUBY_VERSION}"
      }.returns(@json)
      @linode.send_request('test.echo', { })
    end

    it 'should set the designated request method as the HTTP API action' do
      HTTParty.expects(:post).with { |path, args|
        args[:body][:api_action] == 'test.echo'
      }.returns(@json)
      @linode.send_request('test.echo', { })
    end

    it 'should set the response format to JSON' do
      HTTParty.expects(:post).with { |path, args|
        args[:body][:api_responseFormat] == 'json'
      }.returns(@json)
      @linode.send_request('test.echo', { })
    end

    it 'should provide the data hash to the HTTP API request' do
      HTTParty.expects(:post).with { |path, args|
        args[:body]['foo'] == 'bar'
      }.returns(@json)
      @linode.send_request('test.echo', { 'foo' => 'bar' })
    end

    it 'should not allow overriding the API key via the data hash' do
      HTTParty.expects(:post).with { |path, args|
        args[:body][:api_key] == @api_key
      }.returns(@json)
      @linode.send_request('test.echo', { :api_key => 'h4x0r' })
    end

    it 'should not allow overriding the API action via the data hash' do
      HTTParty.expects(:post).with { |path, args|
        args[:body][:api_action] == 'test.echo'
      }.returns(@json)
      @linode.send_request('test.echo', { :api_action => 'h4x0r' })
    end

    it 'should not allow overriding the API response format via the data hash' do
      HTTParty.expects(:post).with { |path, args|
        args[:body][:api_responseFormat] == 'json'
      }.returns(@json)
      @linode.send_request('test.echo', { :api_responseFormat => 'h4x0r' })
    end

    it 'should fail when the request submission fails' do
      HTTParty.stubs(:post).returns(%Q!{
          "ERRORARRAY":["failure"],
          "ACTION":"test.echo",
          "DATA":{"foo":"bar"}
      }!)
      lambda { @linode.send_request('test.echo', { :api_action => 'failure' }) }.should raise_error
    end

    describe 'when the result is a list of hashes' do
      it 'should return a list of objects with lower-cased methods for the data fields' do
        @json = %Q!{
            "ERRORARRAY":[],
            "ACTION":"test.echo",
            "DATA":[{"FOO":"bar"},{"BAR":"baz"}]
        }!
        @json.stubs(:parsed_response).returns(JSON.parse(@json))

        HTTParty.stubs(:post).returns(@json)
        @linode.send_request('test.echo', {}).first.foo.should == 'bar'
        @linode.send_request('test.echo', {}).last.bar.should == 'baz'
      end

      it 'should return a list of objects which do not respond to upper-case URLs for the data fields' do
        @json = %Q!{
            "ERRORARRAY":[],
            "ACTION":"test.echo",
            "DATA":[{"FOO":"bar"},{"BAR":"baz"}]
        }!
        @json.stubs(:parsed_response).returns(JSON.parse(@json))

        HTTParty.stubs(:post).returns(@json)
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
        @json = %Q!{
            "ERRORARRAY":[],
            "ACTION":"test.echo",
            "DATA":"thingie"
        }!
        @json.stubs(:parsed_response).returns(JSON.parse(@json))
        HTTParty.stubs(:post).returns(@json)
        @linode.send_request('test.echo', {}).should == "thingie"
      end
    end

    it 'should be able to parse real JSON when processing a request' do
      json = '{"ERRORARRAY":[],"DATA":[{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":90,"IS64BIT":0,"LABEL":"Arch Linux 2011.08","MINIMAGESIZE":500,"CREATE_DT":"2011-09-26 17:18:05.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":91,"IS64BIT":1,"LABEL":"Arch Linux 2011.08 64bit","MINIMAGESIZE":500,"CREATE_DT":"2011-09-26 17:18:05.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":88,"IS64BIT":0,"LABEL":"CentOS 6.2","MINIMAGESIZE":800,"CREATE_DT":"2011-07-19 11:38:20.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":89,"IS64BIT":1,"LABEL":"CentOS 6.2 64bit","MINIMAGESIZE":800,"CREATE_DT":"2011-07-19 11:38:20.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":77,"IS64BIT":0,"LABEL":"Debian 6","MINIMAGESIZE":550,"CREATE_DT":"2011-02-08 16:54:31.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":78,"IS64BIT":1,"LABEL":"Debian 6 64bit","MINIMAGESIZE":550,"CREATE_DT":"2011-02-08 16:54:31.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":94,"IS64BIT":0,"LABEL":"Fedora 16","MINIMAGESIZE":1000,"CREATE_DT":"2012-04-09 14:12:04.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":95,"IS64BIT":1,"LABEL":"Fedora 16 64bit","MINIMAGESIZE":1000,"CREATE_DT":"2012-04-09 14:12:32.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":72,"IS64BIT":0,"LABEL":"Gentoo","MINIMAGESIZE":1000,"CREATE_DT":"2010-09-13 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":53,"IS64BIT":1,"LABEL":"Gentoo 64bit","MINIMAGESIZE":1000,"CREATE_DT":"2009-04-04 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":96,"IS64BIT":0,"LABEL":"openSUSE 12.1","MINIMAGESIZE":1000,"CREATE_DT":"2012-04-13 11:43:30.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":97,"IS64BIT":1,"LABEL":"openSUSE 12.1 64bit","MINIMAGESIZE":1000,"CREATE_DT":"2012-04-13 11:43:30.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":86,"IS64BIT":0,"LABEL":"Slackware 13.37","MINIMAGESIZE":600,"CREATE_DT":"2011-06-05 15:11:59.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":87,"IS64BIT":1,"LABEL":"Slackware 13.37 64bit","MINIMAGESIZE":600,"CREATE_DT":"2011-06-05 15:11:59.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":64,"IS64BIT":0,"LABEL":"Ubuntu 10.04 LTS","MINIMAGESIZE":450,"CREATE_DT":"2010-04-29 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":65,"IS64BIT":1,"LABEL":"Ubuntu 10.04 LTS 64bit","MINIMAGESIZE":450,"CREATE_DT":"2010-04-29 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":92,"IS64BIT":0,"LABEL":"Ubuntu 11.10","MINIMAGESIZE":750,"CREATE_DT":"2011-10-14 14:29:42.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":93,"IS64BIT":1,"LABEL":"Ubuntu 11.10 64bit","MINIMAGESIZE":850,"CREATE_DT":"2011-10-14 14:29:42.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":59,"IS64BIT":0,"LABEL":"CentOS 5.6","MINIMAGESIZE":950,"CREATE_DT":"2009-08-17 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":60,"IS64BIT":1,"LABEL":"CentOS 5.6 64bit","MINIMAGESIZE":950,"CREATE_DT":"2009-08-17 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":50,"IS64BIT":0,"LABEL":"Debian 5.0","MINIMAGESIZE":350,"CREATE_DT":"2009-02-19 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":51,"IS64BIT":1,"LABEL":"Debian 5.0 64bit","MINIMAGESIZE":350,"CREATE_DT":"2009-02-19 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":84,"IS64BIT":0,"LABEL":"Fedora 15","MINIMAGESIZE":900,"CREATE_DT":"2011-05-25 18:57:36.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":85,"IS64BIT":1,"LABEL":"Fedora 15 64bit","MINIMAGESIZE":900,"CREATE_DT":"2011-05-25 18:58:07.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":79,"IS64BIT":0,"LABEL":"openSUSE 11.4","MINIMAGESIZE":650,"CREATE_DT":"2011-03-10 11:36:46.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":80,"IS64BIT":1,"LABEL":"openSUSE 11.4 64bit","MINIMAGESIZE":650,"CREATE_DT":"2011-03-10 11:36:46.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":68,"IS64BIT":0,"LABEL":"Slackware 13.1","MINIMAGESIZE":512,"CREATE_DT":"2010-05-10 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":69,"IS64BIT":1,"LABEL":"Slackware 13.1 64bit","MINIMAGESIZE":512,"CREATE_DT":"2010-05-10 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":73,"IS64BIT":0,"LABEL":"Ubuntu 10.10","MINIMAGESIZE":500,"CREATE_DT":"2010-10-11 15:19:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":74,"IS64BIT":1,"LABEL":"Ubuntu 10.10 64bit","MINIMAGESIZE":500,"CREATE_DT":"2010-10-11 15:19:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":82,"IS64BIT":0,"LABEL":"Ubuntu 11.04","MINIMAGESIZE":500,"CREATE_DT":"2011-04-28 16:28:48.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":83,"IS64BIT":1,"LABEL":"Ubuntu 11.04 64bit","MINIMAGESIZE":500,"CREATE_DT":"2011-04-28 16:28:48.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":41,"IS64BIT":0,"LABEL":"Ubuntu 8.04 LTS","MINIMAGESIZE":350,"CREATE_DT":"2008-04-23 15:11:29.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":42,"IS64BIT":1,"LABEL":"Ubuntu 8.04 LTS 64bit","MINIMAGESIZE":350,"CREATE_DT":"2008-06-03 12:51:11.0"}],"ACTION":"avail.distributions"}'
      json.stubs(:parsed_response).returns(JSON.parse(json))
      HTTParty.stubs(:post).returns(json)
      @linode.stubs(:api_url).returns('https://fake.linode.com/')

      lambda { @linode.send_request('test.echo', {}) }.should_not raise_error
    end
  end


  it 'should be able to provide access to the Linode Test API' do
    @linode.should respond_to(:test)
  end

  describe 'when providing access to the Linode Test API' do
    it 'should allow no arguments' do
      lambda { @linode.test }.should_not raise_error
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
      lambda { @linode.avail }.should_not raise_error
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
      lambda { @linode.user }.should_not raise_error
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
      lambda { @linode.domain }.should_not raise_error
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
      lambda { @linode.linode }.should_not raise_error
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

  it 'should be able to provide access to the Linode Account API' do
    @linode.should respond_to(:account)
  end

  describe 'when providing access to the Linode Account API' do
    it 'should allow no arguments' do
      lambda { @linode.account }.should_not raise_error
    end

    it 'should require no arguments' do
      lambda { @linode.account(:foo) }.should raise_error(ArgumentError)
    end

    it 'should return a Linode::Account instance' do
      @linode.account.class.should == Linode::Account
    end

    it 'should set the API key on the Linode::Account instance to be our API key' do
      @linode.account.api_key.should == @api_key
    end

    it 'should set the API url on the Linode::Account instance to be our API url' do
      @linode.account.api_url.should == @api_url
    end

    it 'should return the same Linode::Account instance when called again' do
      linode = Linode.new(:api_key => @api_key)
      result = linode.account
      linode.account.should == result
    end
  end

  it 'should be able to provide access to the Linode Nodebalancer API' do
    @linode.should respond_to(:nodebalancer)
  end

  describe 'when providing access to the Linode Nodebalancer API' do
    it 'should allow no arguments' do
      lambda { @linode.nodebalancer }.should_not raise_error
    end

    it 'should require no arguments' do
      lambda { @linode.nodebalancer(:foo) }.should raise_error(ArgumentError)
    end

    it 'should return a Linode::Nodebalancer instance' do
      @linode.nodebalancer.class.should == Linode::Nodebalancer
    end

    it 'should set the API key on the Linode::Nodebalancer instance to be our API key' do
      @linode.nodebalancer.api_key.should == @api_key
    end

    it 'should set the API url on the Linode::Nodebalancer instance to be our API url' do
      @linode.nodebalancer.api_url.should == @api_url
    end

    it 'should return the same Linode::Nodebalancer instance when called again' do
      linode = Linode.new(:api_key => @api_key)
      result = linode.nodebalancer
      linode.nodebalancer.should == result
    end
  end

  it 'should be able to provide access to the Linode Stackscript API' do
    @linode.should respond_to(:stackscript)
  end

  describe 'when providing access to the Linode Stackscript API' do
    it 'should allow no arguments' do
      lambda { @linode.stackscript }.should_not raise_error
    end

    it 'should require no arguments' do
      lambda { @linode.stackscript(:foo) }.should raise_error(ArgumentError)
    end

    it 'should return a Linode::Stackscript instance' do
      @linode.stackscript.class.should == Linode::Stackscript
    end

    it 'should set the API key on the Linode::Stackscript instance to be our API key' do
      @linode.stackscript.api_key.should == @api_key
    end

    it 'should set the API url on the Linode::Stackscript instance to be our API url' do
      @linode.stackscript.api_url.should == @api_url
    end

    it 'should return the same Linode::Stackscript instance when called again' do
      linode = Linode.new(:api_key => @api_key)
      result = linode.stackscript
      linode.stackscript.should == result
    end
  end

  describe 'when providing access to the Linode Image API' do
    it 'should allow no arguments' do
      lambda { @linode.image }.should_not raise_error
    end

    it 'should require no arguments' do
      lambda { @linode.image(:foo) }.should raise_error(ArgumentError)
    end

    it 'should return a Linode::Image instance' do
      @linode.image.class.should == Linode::Image
    end

    it 'should set the API key on the Linode::Image instance to be our API key' do
      @linode.image.api_key.should == @api_key
    end

    it 'should set the API url on the Linode::Image instance to be our API url' do
      @linode.image.api_url.should == @api_url
    end

    it 'should return the same Linode::Image instance when called again' do
      linode = Linode.new(:api_key => @api_key)
      result = linode.image
      linode.image.should == result
    end
  end
end
