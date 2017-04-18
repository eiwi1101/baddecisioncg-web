require 'rails_helper'

feature 'Round Play', js: true do
  let!(:expansion) { create :expansion, :with_cards, story_count: 5, card_count: 15 }
  let!(:lobby) { create :lobby }
  let!(:user) { lobby.join }
  let!(:game) { lobby.new_game }
  let!(:player) { game.join user }
  let!(:round) { game.next_round }

  before(:each) do
    set_lobby_user user
    visit lobby_path lobby
  end

  scenario 'user has cards' do
    expect_content 'current-player', player.guid
    expect_content 'round-data', round.guid
    expect_content 'round-story', round.story_card.uuid
    expect_content 'player-cards', player.cards.first.uuid
  end

  scenario 'user fills bard slots' do
    fool = player.player_cards.fools.first
    crisis = player.player_cards.crisis.first
    decision = player.player_cards.bad_decisions.first

    within "#card-#{fool.guid}" do
      click_link 'Play'
    end

    expect_content 'fool-blank', fool.guid
    expect_content 'fool-hand', fool.guid

    within "#card-#{decision.guid}" do
      click_link 'Play'
    end

    expect(page).to have_content "card doesn't fit"

    within "#card-#{crisis.guid}" do
      click_link 'Play'
    end

    expect_content 'crisis-blank', crisis.guid

    # Card is removed from hand when bard plays.
    expect_content 'crisis-hand', crisis.guid, false
    expect_content 'fool-hand', fool.guid, false
  end

  scenario 'player sees bard slot fills'

  scenario 'player plays cards'

  scenario 'bard picks winner'

  scenario 'game reaches max score'
end
