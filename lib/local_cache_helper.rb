module LocalCacheHelper

  def self.included(base)
    base.before_filter({}) do |controller|
      controller.cache_store.clear_local
    end
  end
  
  def when_fragment_expired(name, options = nil)
    unless cache_store.read(fragment_cache_key(name), options)
      yield
    end
  end

end
