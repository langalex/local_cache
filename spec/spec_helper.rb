require 'rubygems'

require 'active_support'
require 'action_controller/caching/fragments'

Dir.glob(File.dirname(__FILE__) + '/../lib/*.rb').each do |file|
  require file
end

