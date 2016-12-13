class LobbyChannel < ApplicationCable::Channel
  def subscribed
    lobby = Lobby.find_by(token: params[:lobby])

    if lobby&.has_user?(params[:user_id])
      stream_for lobby
    end
  end

  def unsubscribed
    lobby = Lobby.find_by(token: params[:lobby])

    lobby&.leave(params[:user_id])
  rescue Exceptions::UserLobbyViolation
    nil
  end
end
