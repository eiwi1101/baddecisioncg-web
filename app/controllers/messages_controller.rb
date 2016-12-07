class MessagesController < ApplicationController
  before_action :get_lobby

  def create
    @message = Message.create(message_params)
  end

  private

  def message_params
    params.require(:message).permit(:message).merge(lobby: @lobby, user: current_user)
  end

  def get_lobby
    @lobby = Lobby.find_by!(token: params[:lobby_id])
  end
end
