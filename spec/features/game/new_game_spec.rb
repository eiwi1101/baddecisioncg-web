require 'rails_helper'

feature 'New Game', js: true do
  let!(:expansion) { create :expansion, :with_cards, story_count: 5, card_count: 15 }
  let(:lobby) { create :lobby }
  let(:user) { nil }

  before(:each) do
    set_lobby_user user
    visit lobby_path lobby
  end

  scenario 'lobby user is created' do
    expect_content 'lobby-data', lobby.token
    expect_content 'lobby-users', lobby.lobby_users.first.guid
    expect_content 'current-user', lobby.lobby_users.first.guid

    reload_page
    expect_content 'current-user', lobby.lobby_users.first.guid
  end

  scenario 'user creates game' do
    click 'New Game'
    expect(lobby.reload.games).to have(1).items
    expect_content 'game-players', '[]'
    expect_content 'game-data', lobby.games.first.guid

    reload_page
    expect_content 'game-data', lobby.games.first.guid
  end

  context 'with user' do
    let(:user) { lobby.join }

    scenario 'user sees user updates' do
      expect_content 'current-user', user.guid
      expect_content 'lobby-users', user.guid

      new_user = lobby.join
      expect(page).to have_content "#{new_user.name} has joined"
      expect_content 'lobby-users', new_user.guid

      lobby.leave new_user
      expect(page).to have_content "#{new_user.name} has left"
      expect(page).to have_no_content new_user.guid
    end

    context 'with game' do
      let(:game) { lobby.new_game }

      scenario 'user joins game' do
        expect_content 'game-data', game.guid
        expect_content 'game-data', 'isReady":false'

        click 'Join Game'
        expect(game.reload.players).to have(1).items
        expect_content 'game-players', game.players.first.guid
        expect_content 'current-player', game.players.first.guid
        expect_content 'round-data', 'null'

        reload_page
        expect_content 'current-player', game.players.first.guid
      end

      context 'with player' do
        let(:player) { game.join user }

        scenario 'user starts round' do
          expect_content 'current-player', player.guid

          click 'Start Game'
          expect(game.reload.rounds).to have(1).items
          expect_content 'round-data', game.rounds.last.guid
          expect(page).to have_content 'in_progress'
          expect_content 'game-data', 'in_progress'

          reload_page
          expect_content 'round-data', game.rounds.last.guid
        end

        scenario 'user sees player join' do
          expect_content 'game-players', player.guid
          expect_content 'current-player', player.guid

          new_player = game.join lobby.join
          expect_content 'game-players', new_player.guid
        end

        scenario 'player abandons on refresh' do
          expect_content 'current-player', player.guid

          visit lobbies_path
          expect(page).to have_no_content player.guid

          visit lobby_path lobby
          expect(page).to have_content 'lobby has closed'
        end

        scenario 'player remains on refresh with other guests' do
          expect_content 'current-player', player.guid

          new_player = game.join lobby.join
          expect_content 'game-players', new_player.guid

          visit lobbies_path
          expect(page).to have_no_content player.guid

          visit lobby_path lobby
          expect_content 'game-players', player.guid
        end
      end
    end
  end
end
