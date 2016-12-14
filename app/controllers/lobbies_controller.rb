class LobbiesController < ApplicationController
  before_action :get_lobby, only: [:show, :update, :destroy]

  def index
    @lobbies = Lobby.all.reverse
  end

  def new
    @lobby = Lobby.new(name: Faker::Hacker.ingverb.humanize + ' ' + Faker::Team.creature.humanize)

    if @lobby.save
      slack_message "New lobby started!", name: @lobby.name
      redirect_to @lobby
    else
      redirect_to lobbies_path, flash: { notice: 'That hurt.' }
    end
  end

  def show
    respond_to do |format|
      @lobby_user = @lobby.join(current_user)
      sign_in_lobby_user @lobby_user

      format.json { render json: @lobby, serializer: LobbyStateSerializer }
      format.html { render component: 'App', props: {
          lobby_user_id: @lobby_user.guid
      }.merge(LobbyStateSerializer.new(@lobby).as_json) }
    end
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

  def get_lobby
    @lobby = Lobby.with_deleted.includes(:lobby_users => [ :user ],
                                         :games => [ :players, :rounds ])
        .find_by!(token: params[:id])

    if !@lobby
      redirect_to lobbies_path, flash: { error: 'Game lobby not found.' }
      false
    elsif @lobby.deleted?
      redirect_to lobbies_path, flash: { error: 'This lobby has closed.' }
      false
    end
  end
end
