class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector
  include SessionModule

  protect_from_forgery

  # stop rejecting incompatible ua
  before_action :fetch_current_user!, :apply_user_time_zone, :reject_incompatible_ua
  rescue_from Exception, with: :render_500 if Rails.env.production?

  def render_404(exception = nil)
    @title = "ページが見つかりません"
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end
    render :file => "errors/404", :status => 404, :layout => "error", :content_type => 'text/html'
  end

  def render_500(exception = nil)
    ExceptionNotifier.notify_exception(exception, env: request.env)
    @title = "サーバーエラー"
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end
    render :file => "errors/500", :status => 500, :layout => "error", :content_type => 'text/html'
  end

  def is_available_ua?
    # reject msie whose version is not 9
    ua = request.env['HTTP_USER_AGENT'].to_s
    @myua = ua
    if ua.include?("MSIE")
      # check its version
      return false unless ua.include?("9.0")
    end
    true
  end

  def reject_incompatible_ua

    if request.xhr? then return true end
    if params[:action] == "browsers" then return true end

    unless is_available_ua?
      redirect_to :controller => "users", :action => "browsers"
    end
  end

  def apply_user_time_zone
    if @current_user
      Time.zone = @current_user.time_zone
    else
      Time.zone = cookies[:timezone] || 'UTC'
    end
  end

  def check_login
    unless logged_in?
      redirect_to root_url
    else
      return true
    end
  end

  def check_tweet_import
    if check_login
      unless User.find(session[:user_id]).finished_initial_import?
        redirect_to :controller => "statuses", :action => "import"
      end
    end
  end
end
