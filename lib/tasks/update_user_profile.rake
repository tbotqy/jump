namespace :update_user_profile do
  task :for_all_active_users => :environment do
    ProfileUpdateJob.perform_now
  end
end
