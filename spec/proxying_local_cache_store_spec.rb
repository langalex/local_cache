require File.dirname(__FILE__) + '/spec_helper'

describe ProxyingLocalCacheStore, 'read' do
  before(:each) do
    @target_store = stub 'target store', :read => nil
    @store = ProxyingLocalCacheStore.new @target_store
    @store.send(:local_cache).clear
  end
  
  it "should return the data from the local cache" do
    @store.send(:local_cache)['key'] = 'data'
    @store.read('key').should == 'data'
  end
  
  it "should get the data from the cache store if data not found in local cache" do
    @target_store.should_receive(:read).with('key', nil)
    @store.read('key')
  end

  it "should not query the cache store if data found in local cache" do
    @store.send(:local_cache)['key'] = 'data'
    @target_store.should_not_receive(:read)
    @store.read('key')
  end
  
  it "should return the data from the store" do
    @target_store.stub!(:read).and_return('storedata')
    @store.read('').should == 'storedata'
  end
  
  
  it "should store the fragment in the local cache if found in the cache store" do
    @target_store.stub!(:read).and_return('storedata', nil)
    @store.read('key')
    @store.read('key').should == 'storedata'
  end
end


describe ProxyingLocalCacheStore, 'write' do
  
  before(:each) do
    @target_store = stub 'target store', :write => nil, :read => nil
    @store = ProxyingLocalCacheStore.new @target_store
    @store.send(:local_cache).clear
  end
  
  it "should add the data to the local cache" do
    @store.write 'mykey', 'data', {}
    @store.read('mykey').should == 'data'
  end
  
  it 'should delegate the call to the target storage' do
    @target_store.should_receive(:write).with('mykey', 'data', {})
    @store.write 'mykey', 'data', {}
  end
end


describe ProxyingLocalCacheStore, 'clear_local' do
  it "should empty the local cache" do
    @store = ProxyingLocalCacheStore.new stub('target_store', :read => nil)
    @store.send(:local_cache)['key'] = 'data'
    @store.clear_local
    @store.read('key').should be_nil
  end
end

describe ProxyingLocalCacheStore, 'clear' do
  it "should empty the local cache" do
    @store = ProxyingLocalCacheStore.new stub('target_store', :read => nil, :clear => nil)
    @store.send(:local_cache)['key'] = 'data'
    @store.clear
    @store.read('key').should be_nil
  end
  
  it "should clear the target store" do
    target_store = stub('target_store')
    target_store.should_receive(:clear)
    store = ProxyingLocalCacheStore.new target_store
    store.clear
  end
end
