require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'linode'

describe Linode::Linode do
  before :each do
    @api_key = 'foo'
    @linode = Linode::Linode.new(:api_key => @api_key)
  end

  it 'should be a Linode instance' do
    @linode.class.should < Linode
  end

  %w(update create kvmify list mutate shutdown boot delete reboot clone resize).each do |action|
    it "should allow accessing the #{action} API" do
      @linode.should respond_to(action.to_sym)
    end

    describe "when accessing the #{action} API" do
      it 'should allow a data hash' do
        @linode.stubs(:send_request)
        lambda { @linode.send(action.to_sym, {}) }.should_not raise_error
      end

      it 'should not require arguments' do
        @linode.stubs(:send_request)
        lambda { @linode.send(action.to_sym) }.should_not raise_error
      end

      it "should request the linode.#{action} action" do
        @linode.expects(:send_request).with {|api_action, data| api_action == "linode.#{action}" }
        @linode.send(action.to_sym)
      end

      it 'should provide the data hash when making its request' do
        @linode.expects(:send_request).with {|api_action, data| data = { :foo => :bar } }
        @linode.send(action.to_sym, {:foo => :bar})
      end

      it 'should return the result of the request' do
        @linode.expects(:send_request).returns(:bar => :baz)
        @linode.send(action.to_sym).should == { :bar => :baz }
      end

      it "should consider the documentation to live at https://www.linode.com/api/linode/linode.#{action}" do
        @linode.documentation_path(Linode.action_path(@linode.class.name, action)).should == "https://www.linode.com/api/linode/linode.#{action}"
      end
    end
  end

  it 'should be able to provide access to the Linode Config API' do
    @linode.should respond_to(:config)
  end

  describe 'when providing access to the Linode Config API' do
    before :each do
      @api_key = 'foo'
      @api_url = 'https://fake.linode.com/'
      @linode = Linode::Linode.new(:api_key => @api_key, :api_url => @api_url)
    end

    it 'should allow no arguments' do
      lambda { @linode.config }.should_not raise_error
    end

    it 'should require no arguments' do
      lambda { @linode.config(:foo) }.should raise_error(ArgumentError)
    end

    it 'should return a Linode::Linode::Config instance' do
      @linode.config.class.should == Linode::Linode::Config
    end

    it 'should set the API key on the Linode::Linode::Config instance to be our API key' do
      @linode.config.api_key.should == @api_key
    end

    it 'should set the API url on the Linode::Linode::Config instance to be our API url' do
      @linode.config.api_url.should == @api_url
    end

    it 'should return the same Linode::Linode::Config instance when called again' do
      linode = Linode::Linode.new(:api_key => @api_key)
      result = linode.config
      linode.config.should == result
    end
  end

  it 'should be able to provide access to the Linode Disk API' do
    @linode.should respond_to(:disk)
  end

  describe 'when providing access to the Linode Disk API' do
    before :each do
      @api_key = 'foo'
      @api_url = 'https://fake.linode.com/'
      @linode = Linode::Linode.new(:api_key => @api_key, :api_url => @api_url)
    end

    it 'should allow no arguments' do
      lambda { @linode.disk }.should_not raise_error
    end

    it 'should require no arguments' do
      lambda { @linode.disk(:foo) }.should raise_error(ArgumentError)
    end

    it 'should return a Linode::Linode::Disk instance' do
      @linode.disk.class.should == Linode::Linode::Disk
    end

    it 'should set the API key on the Linode::Linode::Disk instance to be our API key' do
      @linode.disk.api_key.should == @api_key
    end

    it 'should set the API url on the Linode::Linode::Disk instance to be our API url' do
      @linode.disk.api_url.should == @api_url
    end

    it 'should return the same Linode::Linode::Disk instance when called again' do
      linode = Linode::Linode.new(:api_key => @api_key)
      result = linode.disk
      linode.disk.should == result
    end
  end

  it 'should be able to provide access to the Linode Job API' do
    @linode.should respond_to(:job)
  end

  describe 'when providing access to the Linode Job API' do
    before :each do
      @api_key = 'foo'
      @api_url = 'https://fake.linode.com/'
      @linode = Linode::Linode.new(:api_key => @api_key, :api_url => @api_url)
    end

    it 'should allow no arguments' do
      lambda { @linode.job }.should_not raise_error
    end

    it 'should require no arguments' do
      lambda { @linode.job(:foo) }.should raise_error(ArgumentError)
    end

    it 'should return a Linode::Linode::Job instance' do
      @linode.job.class.should == Linode::Linode::Job
    end

    it 'should set the API key on the Linode::Linode::Job instance to be our API key' do
      @linode.job.api_key.should == @api_key
    end

    it 'should set the API url on the Linode::Linode::Job instance to be our API url' do
      @linode.job.api_url.should == @api_url
    end

    it 'should return the same Linode::Linode::Job instance when called again' do
      linode = Linode::Linode.new(:api_key => @api_key)
      result = linode.job
      linode.job.should == result
    end
  end

  it 'should be able to provide access to the Linode Ip API' do
    @linode.should respond_to(:ip)
  end

  describe 'when providing access to the Linode Ip API' do
    before :each do
      @api_key = 'foo'
      @api_url = 'https://fake.linode.com/'
      @linode = Linode::Linode.new(:api_key => @api_key, :api_url => @api_url)
    end

    it 'should allow no arguments' do
      lambda { @linode.ip }.should_not raise_error
    end

    it 'should require no arguments' do
      lambda { @linode.ip(:foo) }.should raise_error(ArgumentError)
    end

    it 'should return a Linode::Linode::Ip instance' do
      @linode.ip.class.should == Linode::Linode::Ip
    end

    it 'should set the API key on the Linode::Linode::Ip instance to be our API key' do
      @linode.ip.api_key.should == @api_key
    end

    it 'should set the API url on the Linode::Linode::Ip instance to be our API url' do
      @linode.ip.api_url.should == @api_url
    end

    it 'should return the same Linode::Linode::Linode instance when called again' do
      linode = Linode::Linode.new(:api_key => @api_key)
      result = linode.ip
      linode.ip.should == result
    end
  end
end
