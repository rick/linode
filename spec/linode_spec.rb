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

      it 'should fail if no API key is given' do
        lambda { Linode.new({}) }.should raise_error(ArgumentError)        
      end
      
      it 'should return a Linode instance' do
        Linode.new(:api_key => 'foo').class.should == Linode
      end
    end
  end
  
  it 'should be able to return the API key provided at creation time' do
    Linode.new(:api_key => 'foo').api_key.should == 'foo'
  end
end

