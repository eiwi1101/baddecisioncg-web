class MessagesController < ApplicationController
  before_action :get_lobby

  def index
    @messages = @lobby.messages.includes(:lobby_user).last(10)
    respond_with @messages, each_serializer: MessageSerializer
  end

  def create
    message = message_params['message']

    if message =~ /^\/(\S+)(?:\s+(\S+))?$/
      @lobby.slash_command $1, $2
      @message = Message.new(message_params)
    else
      @message = Message.create(message_params)
    end
  end

  private

  def message_params
    params.require(:message).permit(:message).merge(lobby: @lobby, lobby_user: current_lobby_user)
  end

  def get_lobby
    @lobby = Lobby.find_by!(token: params[:lobby_id])
  end
end
