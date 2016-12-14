module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    cookies.signed[:user_id] = user.id
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    cookies.signed[:user_id] = @current_user&.id
    @current_user
  end

  def sign_in_lobby_user(lobby_user)
    cookies.signed[:lobby_user_id] = lobby_user.id
    @current_lobby_user = lobby_user
    Rails.logger.info "#{lobby_user.name} has signed in."
  end

  def current_lobby_user
    @current_loby_user ||= LobbyUser.find_by(id: cookies.signed[:lobby_user_id])
    cookies.signed[:lobby_user_id] = @current_lobby_user&.id
    @current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    @current_user = nil
    session.delete :user_id
    cookies.signed[:user_id] = nil
  end
end
