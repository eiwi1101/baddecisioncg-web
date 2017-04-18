class LobbyUserChannel < ApplicationCable::Channel
  def subscribed
    @lobby_user = current_lobby_users.joins(:lobby).find_by('lobby_users.guid' => params[:userId], 'lobbies.token' => params[:lobbyId])

    if @lobby_user
      Rails.logger.info "Lobby User #{@lobby_user.guid} is now accepting applications for butlership."
      stream_for @lobby_user
    else
      Rails.logger.warn "Could not connect #{params.inspect} lobby_user channel."
      reject
    end
  end
end
