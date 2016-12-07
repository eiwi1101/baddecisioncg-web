class LobbyChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "Locating game lobby #{params[:lobby]}"
    lobby = Lobby.find_by(token: params[:lobby])

    if lobby&.has_user? current_user
      stream_for lobby
    else
      # TODO Handle Error
    end
  end

  def unsubscribed
    Rails.logger.info "Leaving game lobby #{params[:lobby]}"
    lobby = Lobby.find_by(token: params[:lobby])

    lobby&.leave(current_user)
  rescue Exceptions::UserLobbyViolation
    nil
  end
end
