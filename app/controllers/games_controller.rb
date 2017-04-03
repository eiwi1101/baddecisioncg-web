class GamesController < ApplicationController
  before_action :get_game, only: [:show]
  before_action :get_lobby, only: [:create]

  def create
    @game = @lobby.new_game
    respond_with @game, serializer: GameSerializer
  end

  def show
    respond_with @game, serializer: GameSerializer
  end

  def start
    @game = Game.includes(:players).find_by!(guid: params[:id])

    if @game.start
      flash.now[:notice] = t('game_status.starting')
    else
      flash.now[:error] = @game.errors.full_messages.to_sentence
    end

    render 'create'
  end

  private

  def get_game
    @game = Game.find_by!(guid: params[:id])
  end

  def get_lobby
    @lobby = Lobby.find(params[:lobby_id])
  end
end
