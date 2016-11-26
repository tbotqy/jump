namespace :unicorn do
  #
  # Tasks
  #
  desc "Start unicorn with dest enviroment specified"
  namespace :start do
    task(:development){ sh "bundle exec unicorn_rails -c #{config} -E development -D" }
    task(:production) { sh "bundle exec unicorn_rails -c #{config} -E production -D" }
  end

  desc "Stop unicorn"
  task(:stop){ unicorn_signal :QUIT }

  desc "Restart unicorn with USR2"
  task(:restart){ unicorn_signal :USR2 }

  desc "Increment number of worker processes"
  task(:increment){ unicorn_signal :TTIN }

  desc "Decrement number of worker processes"
  task(:decrement){ unicorn_signal :TTOU }

  desc "Unicorn pstree (depends on pstree command)"
  task(:pstree) do
    sh "pstree '#{unicorn_pid}'"
  end

  #
  # Helpers
  #
  def config
    rails_root + "config/unicorn.rb"
  end

  def unicorn_signal(signal)
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    begin
      File.read(rails_root + "tmp/pids/unicorn.pid").to_i
    rescue Errno::ENOENT
      raise "Unicorn doesn't seem to be running"
    end
  end

  def rails_root
    require "pathname"
    Pathname.new(__FILE__) + "../../.."
  end
end
