require "yaml"
RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)
RAILS_ENV  = ENV['RAILS_ENV'] || 'development'
CONFIG     = YAML.load_file(RAILS_ROOT + "/config/unicorn/enviroments.yml")[RAILS_ENV]

worker_processes CONFIG["worker_num"]
preload_app true
timeout     60
listen      CONFIG["socket_path"], :backlog => 1024
pid         CONFIG["pid_path"]
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
