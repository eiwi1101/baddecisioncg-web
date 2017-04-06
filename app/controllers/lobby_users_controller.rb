class LobbyUsersController < ApplicationController
  before_action :get_lobby_user, only: [:show, :destroy]

  def show
    respond_with @lobby_user, serializer: LobbyUserSerializer
  end

  def destroy
    @lobby_user&.leave!
    respond_with @lobby_user, serializer: LobbyUserSerializer
  end

  private

  def get_lobby_user
    @lobby_user = LobbyUser.with_deleted.find_by!(guid: params[:id])
  end
end
