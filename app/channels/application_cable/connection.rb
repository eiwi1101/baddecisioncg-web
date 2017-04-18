module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_lobby_users

    def connect
      unless Rails.env.test?
        self.current_lobby_users = find_lobby_users
        Rails.logger.info "Connected as #{self.current_lobby_users.pluck(:name)}"
      end
    end

    private

    def find_lobby_users
      users = LobbyUser.where(guid: cookies.signed[:lobby_user_ids].split(','))

      unless users
        Rails.logger.warn "Issue finding current user: #{cookies.signed[:lobby_user_ids].inspect}"
        reject_unauthorized_connection
      end

      users
    end
  end
end
