# frozen_string_literal: true

namespace :deploy do
  task :restart_puma do
    invoke "puma:stop"
    invoke "puma:start"
  end

  after "deploy:finished", "restart_puma"
end
