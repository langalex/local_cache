class ProxyingLocalCacheStore
  
  @@local_cache = {}
  
  
  def initialize(store)
    @store = store
  end
  
  delegate :delete, :exist?, :inrement, :decrement, :stats, :write, :to => :store
  
  def read(key, options = nil)
    local_cache[key] ||= store.read(key, options)
  end
  
  def write(key, data, options)
    local_cache[key] = data
    store.write key, data, options
  end
  
  def clear_local
    local_cache.clear
  end
  
  def clear
    clear_local
    store.clear
  end
  
  private
  
  attr_accessor :store
  
  def local_cache
    @@local_cache
  end
  
end