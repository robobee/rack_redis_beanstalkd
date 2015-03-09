module Processor

  require 'beaneater'
  require 'redis'
  
  @beanstalk = Beaneater::Pool.new(["localhost:11300"])
  @tube = @beanstalk.tubes.find("main-tube")
  @r = Redis.new
  
  @processing = true
  
  while @processing do
    job = @tube.reserve
    case job.body
    when /quit/
      @processing = false
    when /cleanup/
      to_del = @r.keys.select{ |key| @r.get(key) == "finished" }
      @r.del(*to_del) unless to_del.length == 0 
    when /do_something/
      @r.set(job.stats.id.to_s, 'processing')
      puts 'zzzzzzzzz'
      sleep(10)
      @r.set(job.stats.id.to_s, 'finished')
      job.delete
    end
  end

end
