module LocalCacheHelper
  def self.included(base)
    
    base.before_filter({}) do |controller|
      controller.cache_store.clear_local
    end
  end
  
  def when_fragment_expired(key, options = nil)
    unless cache_store.read(key, options)
      yield
    end
  end
end