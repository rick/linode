require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'linode'

describe Linode::Domain do
  before :each do
    @api_key = 'foo'
    @linode = Linode::Domain.new(:api_key => @api_key)
  end
  
  it 'should be a Linode instance' do
    @linode.class.should < Linode
  end
  
  %w(update create list delete).each do |action|
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
    
      it "should request the domain.#{action} action" do
        @linode.expects(:send_request).with {|api_action, data| api_action == "domain.#{action}" }
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
  
  it 'should be able to provide access to the Linode Domain Resource API' do
    @linode.should respond_to(:resource)
  end
  
  describe 'when providing access to the Linode Domain Resource API' do
    before :each do
      @api_key = 'foo'
      @api_url = 'https://fake.linode.com/'
      @linode = Linode::Domain.new(:api_key => @api_key, :api_url => @api_url)
    end

    it 'should allow no arguments' do
      lambda { @linode.resource }.should_not raise_error(ArgumentError)
    end
    
    it 'should require no arguments' do
      lambda { @linode.resource(:foo) }.should raise_error(ArgumentError)
    end
    
    it 'should return a Linode::Domain::Resource instance' do
      @linode.resource.class.should == Linode::Domain::Resource
    end
    
    it 'should set the API key on the Linode::Domain::Resource instance to be our API key' do
      @linode.resource.api_key.should == @api_key
    end
    
    it 'should set the API url on the Linode::Domain::Resource instance to be our API url' do
      @linode.resource.api_url.should == @api_url
    end
    
    it 'should return the same Linode::Domain::Resource instance when called again' do
      linode = Linode::Domain.new(:api_key => @api_key)
      result = linode.resource
      linode.resource.should == result
    end
  end
end
