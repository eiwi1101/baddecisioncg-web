class LobbyUserChannel < ApplicationCable::Channel
  def subscribed
    @lobby_user = LobbyUser.find_by(guid: params[:lobby_user_id])

    if @lobby_user
      Rails.logger.info "Lobby User #{@lobby_user.guid} is now accepting applications for butlership."
      stream_for @lobby_user
    else
      Rails.logger.warn "Could not connect #{params[:lobby_user_id].inspect} lobby_user channel."
      reject
    end
  end
end
