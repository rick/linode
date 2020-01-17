require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')
require 'linode'

describe Linode::Linode::Config do
  before :each do
    @api_key = 'foo'
    @linode = Linode::Linode::Config.new(:api_key => @api_key)
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

      it "should request the avail.#{action} action" do
        @linode.expects(:send_request).with {|api_action, data| api_action == "linode.config.#{action}" }
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

      it "should consider the documentation to live at https://www.linode.com/apiv3/linode/linode.config.#{action}" do
        @linode.documentation_path(Linode.action_path(@linode.class.name, action)).should == "https://www.linode.com/apiv3/linode/linode.config.#{action}"
      end
    end
  end
end
