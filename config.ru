require File.expand_path(File.dirname(__FILE__)) + '/server'
require 'beaneater'
require 'redis'

@beanstalk = Beaneater::Pool.new(["localhost:11300"])
@tube = @beanstalk.tubes.find("main-tube")
@redis = Redis.new

run Server::Application.new(@tube, @redis)
