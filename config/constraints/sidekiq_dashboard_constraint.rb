class SidekiqDashboardConstraint
  def matches?(request)
    return true unless in_env_to_constraint?
    request.session[:user_id] == Settings.sidekiq_dashboard_user_id
  end

  private

  def in_env_to_constraint?
    Rails.env.production?
  end
end
