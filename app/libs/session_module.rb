module SessionModule
  def fetch_current_user!
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end

  def logged_in?
    session[:user_id].present?
  end

  def login!(user)
    session[:user_id] = user.id
  end

  def logout!
    reset_session
  end
end
