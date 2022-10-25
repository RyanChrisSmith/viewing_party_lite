class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    if !current_user
      flash[:message] = "You will need be registered and then logged in to access that page"
      redirect_back(fallback_location: root_path)
    end
  end
end
