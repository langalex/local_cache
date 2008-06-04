require 'rubygems'
gem 'activesupport'
require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/module/delegation'
gem 'rspec'
require 'spec/mocks'

Dir.glob(File.dirname(__FILE__) + '/../lib/*.rb').each do |file|
  require file
end