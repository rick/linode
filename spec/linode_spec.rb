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
end

describe 'Linode' do  
  before :each do
    @api_key = 'foo'
    @linode = Linode.new(:api_key => @api_key)
  end
  
  it 'should be able to return the API key provided at creation time' do
    @linode.api_key.should == 'foo'
  end
  
  it 'should be able to provide access to the Linode Test API' do
    @linode.should respond_to(:test)
  end
  
  describe 'when providing access to the Linode Test API' do
    it 'should allow no arguments' do
      lambda { @linode.test }.should_not raise_error(ArgumentError)
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
      lambda { @linode.avail }.should_not raise_error(ArgumentError)
    end
    
    it 'should require no arguments' do
      lambda { @linode.avail(:foo) }.should raise_error(ArgumentError)
    end
    
    it 'should return a Linode::Test instance' do
      @linode.avail.class.should == Linode::Avail
    end
    
    it 'should set the API key on the Linode::Test instance to be our API key' do
      @linode.avail.api_key.should == @api_key
    end
    
    it 'should return the same Linode::Test instance when called again' do
      linode = Linode.new(:api_key => @api_key)
      result = linode.avail
      linode.avail.should == result
    end
  end
end

