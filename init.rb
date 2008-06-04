require File.dirname(__FILE__) + '/lib/local_cache_helper'
require File.dirname(__FILE__) + '/lib/proxying_local_cache_store'

ActionController::Base.send :include, LocalCacheHelper

# replace the configured cache store with our proxy
ActionController::Base.cache_store = ProxyingLocalCacheStore.new ActionController::Base.cache_store