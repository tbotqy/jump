# coding:utf-8
# unicron.rb
SITE_URL = ""
NAME = ""
LISTEN = ""

worker_processes  3
working_directory '/var/www/SITE_URL/'

listen '/tmp/unicorn.NAME.sock', :backlog => 1
listen LISTEN, :tcp_nopush => true

pid '/tmp/unicorn.NAME.pid'

timeout 180

stdout_path '/var/www/SITE_URL/log/unicorn.stdout.log'
stderr_path '/var/www/SITE_URL/log/unicorn.stderr.log'

preload_app  true
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  
  sleep 1
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
