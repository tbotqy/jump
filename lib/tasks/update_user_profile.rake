namespace :update_user_profile do
  desc "Update all the active users' profile."
  task :for_all_active_users => :environment do
    ProfileUpdateJob.perform_now
  end
end
