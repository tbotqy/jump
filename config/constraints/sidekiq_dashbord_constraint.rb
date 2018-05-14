class SidekiqDashbordConstraint
  def matches?(request)
    return true unless in_env_to_constraint?
    request.session[:user_id] == configatron.sidekiq_dashbord_user_id
  end

  private

  def in_env_to_constraint?
    Rails.env.production?
  end
end
