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
  
  %w(update create list shutdown boot delete reboot).each do |action|
    it "should allow accessing the #{action} API" do
      @linode.should respond_to(action.to_sym)
    end
  
    describe "when accessing the #{action} API" do
      it 'should allow a data hash' do
        lambda { @linode.send(action.to_sym, {}) }.should_not raise_error(ArgumentError)
      end
    
      it 'should not require arguments' do
        lambda { @linode.send(action.to_sym) }.should_not raise_error(ArgumentError)      
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
      lambda { @linode.config }.should_not raise_error(ArgumentError)
    end
    
    it 'should require no arguments' do
      lambda { @linode.config(:foo) }.should raise_error(ArgumentError)
    end
    
    it 'should return a Linode::Avail instance' do
      @linode.config.class.should == Linode::Linode::Config
    end
    
    it 'should set the API key on the Linode::Domain::Resource instance to be our API key' do
      @linode.config.api_key.should == @api_key
    end
    
    it 'should set the API url on the Linode::Domain::Resource instance to be our API url' do
      @linode.config.api_url.should == @api_url
    end
    
    it 'should return the same Linode::Domain::Resource instance when called again' do
      linode = Linode::Linode.new(:api_key => @api_key)
      result = linode.config
      linode.config.should == result
    end
  end
end
