module Server
  class Application

    def initialize(tube, redis)
      @tube = tube
      @redis = redis
    end

    def call(env)
      headers = { "Content-Type" => "text/plain"}
      status = 200
      case env["PATH_INFO"]
      when /create_job/
        job = @tube.put "do_something"
        @redis.set(job[:id].to_s,'enqueued')
        body = "Job #{job[:id]} enqueued"
      when /stop_processor/
        @tube.put "quit"
        body = "Processor scheduled to stop"
      when /cleanup/
        @tube.put "cleanup"
        body = "Cleaning up"
      else
        body = "Incorrect request"
        status = 500
      end
      [status, headers, ["#{env["PATH_INFO"]} == #{body}\n"]]
    end
  end
end
