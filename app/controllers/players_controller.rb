class PlayersController < ApplicationController
  before_action :get_game

  def create
    Rails.logger.tagged 'Player Create' do
      Rails.logger.debug 'Finding the old lobby user...'
      lobby_user = LobbyUser.with_deleted.find_by(guid: params[:user_id])
      Rails.logger.debug 'We found: ' + lobby_user.inspect

      if lobby_user.deleted?
        lobby_user.restore!(recursive: true)
        Rails.logger.info 'Call a necromancer! (LU restore again)'
      end

      Rails.logger.info 'Joining in all this fun!'
      @player = @game.join(lobby_user, allow_rejoin: true)
      Rails.logger.info 'Look at all this fun we\'re having!'

      respond_with @player, serializer: PlayerSerializer, location: nil
    end
  end

  private

  def get_game
    @game = Game.find_by(guid: params[:game_id])
  end
end
