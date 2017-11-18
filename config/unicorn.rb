RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)

worker_processes 3
preload_app true
timeout     60
listen      "#{RAILS_ROOT}/tmp/unicorn.sock", :backlog => 1024
pid         "#{RAILS_ROOT}/tmp/unicorn.pid"
stdout_path "#{RAILS_ROOT}/log/unicorn_std.log"
stderr_path "#{RAILS_ROOT}/log/unicorn_error.log"

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
  old_pid = "#{ server.config[:pid] }.oldbin"
  if old_pid != server.pid
    begin
      Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{RAILS_ROOT}/Gemfile"
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
