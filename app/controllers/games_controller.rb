class GamesController < ApplicationController
  before_action :get_lobby
  before_action :get_game, only: [:start]

  def create
    @game = @lobby.new_game
    flash.now[:notice] = 'Waiting for players to join!'
  rescue Exceptions::RuleViolation => e
    flash.now[:error] = e.message
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

  def get_lobby
    @lobby = Lobby.find(params[:lobby_id])
  end

  def get_game
    @game = Game.find(params[:id])
  end
end
