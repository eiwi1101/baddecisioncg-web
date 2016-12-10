class LobbyChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "Locating game lobby #{params[:lobby]}"
    lobby = Lobby.find_by(token: params[:lobby])
    Rails.logger.info "Found lobby: #{lobby.token}"

    if lobby&.has_user?(params[:user_id])
      Rails.logger.info "Found user: #{params[:user_id]}"
      stream_for lobby
      lobby.broadcast :connected
    else
      # TODO Handle Error
    end
  end

  def unsubscribed
    Rails.logger.info "Leaving game lobby #{params[:lobby]}"
    lobby = Lobby.find_by(token: params[:lobby])

    lobby&.leave(params[:user_id])
  rescue Exceptions::UserLobbyViolation
    nil
  end
end
