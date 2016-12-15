class LobbyUserChannel < ApplicationCable::Channel
  def subscribed
    @lobby_user = LobbyUser.find_by(guid: params[:lobby_user_id])

    if @lobby_user
      stream_for @lobby_user
      Rails.logger.info "Lobby User #{@lobby_user.name} is now accepting applications for butlership."
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def play(card)
    @lobby_user.lobby.player_pick(card.guid)
  end

  def pick(card)
    @lobby_user.lobby.bard_pick(card.guid)
  end
end
