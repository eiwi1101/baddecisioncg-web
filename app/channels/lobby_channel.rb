class LobbyChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "===> AC Connect: #{params[:lobbyId]}"

    @lobby = Lobby.find_by(token: params[:lobbyId])

    if @lobby&.has_user?(params[:userId])
      stream_for @lobby
    else
      Rails.logger.warn "Rejecting #{@lobby} connection from #{params[:userId]}"
      reject
    end
  end

  def unsubscribed
    @lobby&.leave(params[:userId])
  rescue Exceptions::UserLobbyViolation
    nil
  end
end
