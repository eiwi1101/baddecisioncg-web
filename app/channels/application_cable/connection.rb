module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      Rails.logger.info "Connected as #{self.current_user&.display_name}"
    end

    private

    def find_verified_user
      if (current_user = User.find_by(id: cookies.signed[:user_id]))
        current_user
      else
        nil
      end
    end
  end
end
