class GamesController < ApplicationController
  before_action :get_game, only: [:start]

  def create
    flash.now[:error] = 'Not implemented.'
  end

  def start
    if @game.start
      flash.now[:notice] = 'The game will start shortly.'
    else
      flash.now[:error] = @game.errors.full_messages.to_sentence
    end

    render 'create'
  end

  private

  def get_game
    @game = Game.find(params[:id])
  end
end
