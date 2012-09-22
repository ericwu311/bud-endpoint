require 'redis'

config['app_folder'] = File.expand_path('..', __FILE__)

config['redis'] = Redis.new 

