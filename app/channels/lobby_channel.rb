class LobbyChannel < ApplicationCable::Channel
  def subscribed
    @lobby = Lobby.find_by(token: params[:token])

    if @lobby&.has_user?(params[:lobby_user_id])
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
