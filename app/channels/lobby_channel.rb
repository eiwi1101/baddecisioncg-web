class LobbyChannel < ApplicationCable::Channel
  def subscribed
    @lobby = Lobby.find_by(token: params[:lobbyId])

    if @lobby&.has_user?(params[:userId])
      stream_for @lobby
    else
      Rails.logger.warn "Rejecting #{@lobby} connection from #{params[:lobby_user_id]}"
      reject
    end
  end

  def unsubscribed
    @lobby&.leave(params[:lobby_user_id])
  rescue Exceptions::UserLobbyViolation
    nil
  end
end
