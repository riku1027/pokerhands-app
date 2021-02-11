class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  def render_404
    redirect_to root_path, alert: MSG_WEBALT_INV_URL
  end

  def render500
    redirect_to root_path, alert: MSG_WEBALT_SYS_ERR
  end

end
