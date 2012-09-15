require 'redis'

config['redis'] = Redis.new :path => '../shared/sockets/redis.sock'

