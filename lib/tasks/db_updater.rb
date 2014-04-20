# -*- coding: utf-8 -*-
class Tasks::DbUpdater
  def self.delete_gone_users
    
    deleted_user_count = 0
    
    User.get_gone_users.each do |gone_user|
      if gone_user.destroy 
        deleted_user_count += 1
      end
    end
    
    if deleted_user_count == 0
      print "No user deleted"
    else
      print "Deleted #{deleted_user_count} users"
    end
    
    print " on #{Time.now} .\n\n"
  end
end
