class LobbyUserChannel < ApplicationCable::Channel
  def subscribed
    @lobby_user = LobbyUser.find_by(guid: params[:lobby_user_id])

    if @lobby_user
      Rails.logger.debug "Lobby User #{@lobby_user.guid} is now accepting applications for butlership."
      stream_for @lobby_user
    else
      reject
    end
  end
end
