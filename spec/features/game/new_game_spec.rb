require 'rails_helper'

feature 'New Game', js: true do
  let!(:expansion) { create :expansion, :with_cards, story_count: 5, card_count: 15 }
  let(:lobby) { create :lobby }

  def expect_content(id, content)
    expect(page.find "##{id}").to have_content content
  end

  def click(link_text)
    click_link link_text
    expect(page).to have_no_content link_text
    save_and_open_screenshot
  end

  scenario 'lobby user is created' do
    visit lobby_path lobby
    expect_content 'lobby-data', lobby.token
    expect_content 'lobby-users', lobby.lobby_users.first.guid
    expect_content 'current-user', lobby.lobby_users.first.guid

    reload_page
    expect_content 'current-user', lobby.lobby_users.first.guid
  end

  scenario 'user creates game' do
    visit lobby_path lobby

    click 'New Game'
    expect(lobby.reload.games).to have(1).items
    expect_content 'game-players', '[]'
    expect_content 'game-data', lobby.games.first.guid

    reload_page
    expect_content 'game-data', lobby.games.first.guid
  end

  scenario 'user joins game' do
    game = lobby.new_game
    visit lobby_path lobby

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

  scenario 'user starts round' do
    user = lobby.join
    game = lobby.new_game
    player = game.join user
    page.set_rack_session lobby_user_id: user.id

    visit lobby_path lobby
    expect_content 'current-player', player.guid

    click 'Start Game'
    expect(game.reload.rounds).to have(1).items
    expect_content 'round-data', game.rounds.last.guid
    expect(page).to have_content 'in_progress'
    expect_content 'game-data', 'in_progress'

    reload_page
    expect_content 'round-data', game.rounds.last.guid
  end
end
