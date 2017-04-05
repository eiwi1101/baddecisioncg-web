module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_lobby_user

    def connect
      unless Rails.env.test?
        self.current_lobby_user = find_lobby_user
        Rails.logger.info "Connected as #{self.current_lobby_user&.name}"
      end
    end

    private

    def find_lobby_user
      lobby = Lobby.find_by guid: request.params[:lobbyId]
      user = if Rails.env.test?
               LobbyUser.find_by(id: request.params[:userId], lobby: lobby)
             else
               LobbyUser.find_by(id: cookies.signed[:lobby_user_ids].split(','), lobby: request.params[:lobbyId])
             end

      unless user
        Rails.logger.warn "Issue finding current user: #{cookies.signed[:lobby_user_ids].inspect}"
        reject_unauthorized_connection
      end
    end
  end
end
