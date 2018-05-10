class SidekiqDashbordConstraint
  def matches?(request)
    request.session[:user_id] == configatron.sidekiq_dashbord_user_id
  end
end
