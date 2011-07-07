require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'linode'

describe Linode::Avail do
  before :each do
    @api_key = 'foo'
    @linode = Linode::Avail.new(:api_key => @api_key)
  end
  
  it 'should be a Linode instance' do
    @linode.class.should < Linode
  end
  
  %w(datacenters kernels linodeplans distributions stackscripts).each do |action|
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
    
      it "should request the avail.#{action} action" do
        @linode.expects(:send_request).with {|api_action, data| api_action == "avail.#{action}" }
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
      
      it "should consider the documentation to live at http://www.linode.com/api/utility/avail.#{action}" do
        @linode.documentation_path(Linode.action_path(@linode.class.name, action)).should == "http://www.linode.com/api/utility/avail.#{action}"
      end
    end
  end
end
