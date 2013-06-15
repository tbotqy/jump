class AdminController < ApplicationController

  beforeFilter :check_login
  beforeFilter :admin_user_check

  def admin_user_check
    # check if current user is an admin user
    admin_list = configatron.admin_users.split(/,/)
    
    is_admin = admin_list.include?(@@current_user.twitter_id.to_s)
    
    redirect_to root_url if !is_admin
  end

  def index
  end
  
  def accounts
    @active_users = User.get_active_users
    @gone_users User.get_gone_users
    @show_footer = true
  end
  
  def statuses
  end
  
end
