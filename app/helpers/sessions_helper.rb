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
    session[:lobby_user_ids] ||= []
    session[:lobby_user_ids] << lobby_user.guid

    cookies.signed[:lobby_user_ids] = session[:lobby_user_ids].join(',')

    @current_lobby_user = lobby_user
  end

  def current_lobby_user(lobby=nil)
    if @current_lobby_user&.lobby == lobby
      @current_lobby_user
    else
      # noinspection RailsChecklist05
      @current_lobby_user = LobbyUser.with_deleted.find_by(guid: session[:lobby_user_ids], lobby: lobby)
    end
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
