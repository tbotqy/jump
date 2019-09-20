# frozen_string_literal: true

namespace :deploy do
  task :yarn_build do
    on roles fetch(:yarn_roles) do
      within fetch(:yarn_target_path) do
        execute fetch(:yarn_bin), :build
      end
    end
  end

  before "symlink:release", :yarn_build
end
