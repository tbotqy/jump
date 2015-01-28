# -*- coding: utf-8 -*-
class Tasks::DbUpdater

  def self.delete_gone_users
    deleted_count = User.delete_gone_users
    if deleted_count > 0
      puts "Deleted #{deleted_count} users."
    else 
      puts "No gone user found."
    end
    puts "Finished delete_gone_users at #{Time.now}."
  end
  
  def self.delete_gone_and_duplicated_users
    
    deleted_gone_user_count = User.delete_gone_users
    deleted_duplicated_user_count = User.delete_gone_and_duplicated_users
    
    puts " Deleted gone(#{deleted_gone_user_count}) and duplicated users (#{deleted_duplicated_user_count})"
    puts "Finished delete_gone_and_duplicated_users at #{Time.now}."
  end
  
end
