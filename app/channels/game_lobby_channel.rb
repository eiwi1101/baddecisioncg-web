class GameLobbyChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "Locating game lobby #{params[:lobby]}"
    game_lobby = GameLobby.find_by(token: params[:lobby])

    if game_lobby&.has_user? current_user
      stream_for game_lobby
    else
      # TODO Handle Error
    end
  end

  def unsubscribed
    Rails.logger.info "Unsubscribed from game lobby"
  end
end
