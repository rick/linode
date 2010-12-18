require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'linode'

describe Linode::User do
  before :each do
    @api_key = 'foo'
    @linode = Linode::User.new(:api_key => @api_key)
  end
  
  it 'should be a Linode instance' do
    @linode.class.should < Linode
  end
  
  it 'should be able to return the API key for the connection' do
    @linode.should respond_to(:getapikey)
  end
  
  describe 'when returning the API key for the connection' do
    it 'should work without arguments' do
      lambda { @linode.getapikey }.should_not raise_error(ArgumentError)
    end
    
    it 'should not allow arguments' do
      lambda { @linode.getapikey(:foo) }.should raise_error(ArgumentError)      
    end
    
    it 'should return the api_key via the Linode handle' do
      @linode.stubs(:api_key).returns('foo')
      @linode.getapikey.should == 'foo'
    end
  end
end
