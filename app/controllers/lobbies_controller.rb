class LobbiesController < ApplicationController
  before_action :get_lobby, only: [:show, :update, :destroy]

  def index
    @lobbies = Lobby.all.reverse
  end

  def new
    @lobby = Lobby.new(name: Faker::Hacker.ingverb.humanize + ' ' + Faker::Team.creature.humanize)

    if @lobby.save
      slack_message 'New lobby started!', name: @lobby.name
      redirect_to @lobby
    else
      redirect_to lobbies_path, flash: { notice: 'That hurt.' }
    end
  end

  def show
    if !@lobby
      respond_to do |format|
        error = 'Game lobby not found.'
        format.json { render json: { error: error }, status: :not_found }
        format.html { redirect_to lobbies_path, flash: { error: error } }
      end
    elsif @lobby.deleted?
      respond_to do |format|
        error = 'This lobby has closed.'
        format.json { render json: { error: error }, status: :not_found }
        format.html { redirect_to lobbies_path, flash: { error: error } }
      end
    else
      Rails.logger.tagged 'Lobby Load' do
        Rails.logger.debug 'Starting lobby init (server side, obviously)'

        unless (@lobby_user = current_lobby_user(@lobby.id))
          Rails.logger.debug 'Could not find lobby in session, creating one...'

          @lobby_user = @lobby.join(current_user)
          sign_in_lobby_user @lobby_user

          Rails.logger.debug 'Created: ' + @lobby_user.inspect
        end

        if @lobby_user.deleted?
          Rails.logger.debug 'Restoring from the dead: ' + @lobby_user.inspect

          @lobby_user.restore recursive: true
          @lobby_user.broadcast!

          Rails.logger.debug 'Necromancy complete.'
        end

        Rails.logger.debug 'Init complete, sending response.'

        respond_to do |format|
          format.json { render json: @lobby, serializer: LobbyStateSerializer }
          format.html
        end
      end
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
    @lobby = Lobby.with_deleted.find_by(token: params[:id])
  end
end
