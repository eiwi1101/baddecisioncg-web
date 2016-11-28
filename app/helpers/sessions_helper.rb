module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    @current_user     = user
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    @current_user = nil
    session.delete :user_id
  end
end
