module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_lobby_user

    def connect
      self.current_lobby_user = find_lobby_user
      Rails.logger.info "Connected as #{self.current_lobby_user&.name}"
    end

    private

    def find_lobby_user
      if (current_lobby_user = LobbyUser.find_by(id: cookies.signed[:lobby_user_id]))
        current_lobby_user
      else
        Rails.logger.warn "Issue finding current user: #{cookies.signed[:lobby_user_id].inspect}"
        Rails.logger.warn cookies.signed.inspect
        reject_unauthorized_connection
      end
    end
  end
end
