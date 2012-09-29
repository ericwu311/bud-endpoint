require 'bundler'
Bundler.setup(:default, :test)
Bundler.require(:default, :test)

require_relative '../../config/environment'

require 'goliath/test_helper'
require_relative '../bud_endpoint'

Dir["lib/**/*.rb"].each { |f| require File.expand_path(f) }

Goliath.env = :test

RSpec.configure do |c| 
  c.include Goliath::TestHelper, :example_group => {
    :file_path => /spec\/integration/
  }
end