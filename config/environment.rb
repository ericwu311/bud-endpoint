require 'resque'
$: << File.expand_path("../../lib", __FILE__)

Dir["lib/**/*.rb"].each { |f| require File.expand_path(f) }
