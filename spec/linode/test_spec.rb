require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'linode'

describe Linode::Test do
  before :each do
    @api_key = 'foo'
    @linode = Linode::Test.new(:api_key => @api_key)
  end
  
  it 'should be a Linode instance' do
    @linode.class.should < Linode
  end
  
  it 'should allow accessing the echo API' do
    @linode.should respond_to(:echo)
  end
  
  describe 'when accessing the echo API' do
    it 'should allow a data hash' do
      lambda { @linode.echo({}) }.should_not raise_error(ArgumentError)
    end
    
    it 'should not require arguments' do
      lambda { @linode.echo }.should_not raise_error(ArgumentError)      
    end
    
    it 'should request the test.echo action' do
      @linode.expects(:send_request).with {|action, data| action == 'test.echo' }
      @linode.echo
    end
    
    it 'should provide the data hash when making its request' do
      @linode.expects(:send_request).with {|action, data| data = { :foo => :bar } }
      @linode.echo(:foo => :bar)
    end
    
    it 'should return the result of the request' do
      @linode.expects(:send_request).returns(:bar => :baz)      
      @linode.echo.should == { :bar => :baz }      
    end
  end
end
