$: << File.expand_path("../../lib", __FILE__)

require 'active_support/core_ext/numeric/time.rb'
require 'active_support/hash_with_indifferent_access'

require_relative 'resque_conf'


Dir["lib/**/*.rb"].each { |f| require File.expand_path(f) }
