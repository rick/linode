require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'linode'

describe Linode::Nodebalancer do
  before :each do
    @api_key = 'foo'
    @linode = Linode::Nodebalancer.new(:api_key => @api_key)
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
        @linode.stubs(:send_request)
        lambda { @linode.send(action.to_sym, {}) }.should_not raise_error
      end

      it 'should not require arguments' do
        @linode.stubs(:send_request)
        lambda { @linode.send(action.to_sym) }.should_not raise_error
      end

      it "should request the nodebalancer.#{action} action" do
        @linode.expects(:send_request).with {|api_action, data| api_action == "nodebalancer.#{action}" }
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

      it "should consider the documentation to live at http://www.linode.com/api/nodebalancer/nodebalancer.#{action}" do
        @linode.documentation_path(Linode.action_path(@linode.class.name, action)).should == "http://www.linode.com/api/nodebalancer/nodebalancer.#{action}"
      end
    end
  end

  it 'should be able to provide access to the Linode Nodebalancer Config API' do
    @linode.should respond_to(:config)
  end

  describe 'when providing access to the Linode Nodebalancer Config API' do
    before :each do
      @api_key = 'foo'
      @api_url = 'https://fake.linode.com/'
      @linode = Linode::Nodebalancer.new(:api_key => @api_key, :api_url => @api_url)
    end

    it 'should allow no arguments' do
      lambda { @linode.config }.should_not raise_error
    end
    
    it 'should require no arguments' do
      lambda { @linode.config(:foo) }.should raise_error(ArgumentError)
    end

    it 'should return a Linode::Nodebalancer::Config instance' do
      @linode.config.class.should == Linode::Nodebalancer::Config
    end

    it 'should set the API key on the Linode::Nodebalancer::Config instance to be our API key' do
      @linode.config.api_key.should == @api_key
    end

    it 'should set the API url on the Linode::Nodebalancer::Config instance to be our API url' do
      @linode.config.api_url.should == @api_url
    end

    it 'should return the same Linode::Nodebalancer::Config instance when called again' do
      linode = Linode::Nodebalancer.new(:api_key => @api_key)
      result = linode.config
      linode.config.should == result
    end
  end

  it 'should be able to provide access to the Linode Nodebalancer Node API' do
    @linode.should respond_to(:node)
  end

  describe 'when providing access to the Linode Nodebalancer Node API' do
    before :each do
      @api_key = 'foo'
      @api_url = 'https://fake.linode.com/'
      @linode = Linode::Nodebalancer.new(:api_key => @api_key, :api_url => @api_url)
    end

    it 'should allow no arguments' do
      lambda { @linode.node }.should_not raise_error
    end

    it 'should require no arguments' do
      lambda { @linode.node(:foo) }.should raise_error(ArgumentError)
    end

    it 'should return a Linode::Nodebalancer::Node instance' do
      @linode.node.class.should == Linode::Nodebalancer::Node
    end

    it 'should set the API key on the Linode::Nodebalancer::Node instance to be our API key' do
      @linode.node.api_key.should == @api_key
    end

    it 'should set the API url on the Linode::Nodebalancer::Node instance to be our API url' do
      @linode.node.api_url.should == @api_url
    end

    it 'should return the same Linode::Nodebalancer::Node instance when called again' do
      linode = Linode::Nodebalancer.new(:api_key => @api_key)
      result = linode.node
      linode.node.should == result
    end
  end
end
