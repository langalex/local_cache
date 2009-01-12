require File.dirname(__FILE__) + '/spec_helper'

class FragmentHelper
  extend ActionController::Caching::Fragments
end

class MyController
  include ActionController::Caching::Fragments

  def self.before_filter(*args); end
  include LocalCacheHelper
  
  attr_reader :cache_store
  
  def has_block_called?
    @block_called
  end
  
  def my_action
    when_fragment_expired 'frag_name', {} do
      @block_called = true
    end
  end

  def initialize(cache_store)
    @cache_store = cache_store
  end
  
end

describe LocalCacheHelper, 'when_fragment_expired' do

  before(:each) do
    @cache = stub 'cachestore'
    @controller = MyController.new @cache
  end
  
  it "should get the fragment from the cache" do
    @cache.should_receive(:read).with(FragmentHelper.fragment_cache_key('frag_name'), {})
    @controller.my_action
  end
  
  it "should yield the block if cache returns nil" do
    @cache.stub!(:read).and_return(nil)
    @controller.my_action
    @controller.should have_block_called
  end
  
  it "should not execute the block if cache returns the fragment" do
    @cache.stub!(:read).and_return("fragment")
    @controller.my_action
    @controller.should_not have_block_called
  end
  
end
