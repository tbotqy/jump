module SessionModule
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
