class UserChannel < ApplicationCable::Channel
  def subscribed
    if current_user
      stream_for current_user
      current_user.online!
    end
  end

  def unsubscribed
    current_user&.offline!
  end
end
