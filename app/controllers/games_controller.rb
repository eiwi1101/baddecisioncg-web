class GamesController < ApplicationController
  before_action :get_lobby, only: [:create]

  def create
    @game = @lobby.new_game
    flash.now[:notice] = t('game_status.waiting')
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

  def get_lobby
    @lobby = Lobby.find(params[:lobby_id])
  end
end
