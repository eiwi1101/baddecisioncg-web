class GameLobbiesController < ApplicationController
  before_action :get_game_lobby, only: [:show, :update, :destroy]

  def index
    @game_lobbies = GameLobby.all.reverse
  end

  def new
    @game_lobby = GameLobby.new(name: Faker::Hacker.ingverb.humanize + ' ' + Faker::Team.creature.humanize)

    if @game_lobby.save
      redirect_to @game_lobby
    else
      redirect_to game_lobbies_path, flash: { notice: 'That hurt.' }
    end
  end

  def show
    @game_lobby_user = @game_lobby.join(current_user)
  end

  def create
    # THIS SUCKS UP JSON
  end

  def update
    # THIS SUCKS UP JSON, TOO
  end

  def destroy
    # THIS BLOWS SHIT UP
  end

  private

  def get_game_lobby
    @game_lobby = GameLobby.with_deleted.find_by!(token: params[:id])

    if !@game_lobby
      redirect_to game_lobbies_path, flash: { error: 'Game lobby not found.' }
      false
    elsif @game_lobby.deleted?
      redirect_to game_lobbies_path, flash: { error: 'This lobby has closed.' }
      false
    end
  end
end
