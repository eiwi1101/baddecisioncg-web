require 'rails_helper'

feature 'Round Play', js: true do
  let!(:expansion) { create :expansion, :with_cards, story_count: 5, card_count: 15 }
  let!(:lobby) { create :lobby }
  let!(:bard_user) { lobby.join }
  let!(:user) { lobby.join }
  let!(:game) { lobby.new_game }
  let!(:bard) { game.join bard_user }
  let!(:player) { game.join user }
  let!(:player_2) { game.join lobby.join }
  let!(:round) { game.next_round }

  def play_card(card)
    within "#card-#{card.guid}" do
      click_link 'Play'
    end
  end

  context 'as bard' do
    before(:each) do
      set_lobby_user bard_user
      visit lobby_path lobby
    end

    scenario 'user fills bard slots' do
      fool = bard.player_cards.fools.first
      crisis = bard.player_cards.crisis.first
      decision = bard.player_cards.bad_decisions.first

      play_card fool

      expect_content 'fool-blank', fool.guid
      expect_content 'fool-hand', fool.guid, false

      play_card decision

      expect(page).to have_content "card doesn't fit"

      play_card crisis

      expect_content 'crisis-blank', crisis.guid

      # Card is removed from hand when bard plays.
      expect_content 'crisis-hand', crisis.guid, false
      expect_content 'fool-hand', fool.guid, false
    end

    scenario 'bard picks winner' do
      fool = bard.player_cards.fools.first
      crisis = bard.player_cards.crisis.first
      decision = player.player_cards.bad_decisions.first
      decision_2 = player_2.player_cards.in_hand.bad_decisions.first
      round.play bard, fool
      round.play bard, crisis
      round.play player_2, decision_2
      round.play player, decision

      wait_until { round.bard_pick? }
      play_card decision_2

      # THE BARD SHALL DO A WINNING
      new_p2_d = player_2.player_cards.in_hand.bad_decisions.first
      expect(new_p2_d).to_not eq decision_2

      wait_until { player_2.reload.score == 1 }

      expect_content 'bad-decision-blank', decision_2.guid

      click 'Next Round'
      expect_content 'bad-decision-blank', decision_2.guid, false
    end

    scenario 'game reaches max score' do
      game.update_attributes score_limit: 1
      fool = bard.player_cards.fools.first
      crisis = bard.player_cards.crisis.first
      decision = player.player_cards.bad_decisions.first
      decision_2 = player_2.player_cards.in_hand.bad_decisions.first
      round.play bard, fool
      round.play bard, crisis
      round.play player_2, decision_2
      round.play player, decision

      wait_until { round.bard_pick? }
      play_card decision_2

      expect_content 'current-player', bard.guid

      wait_until { game.reload.finished? }
      click 'New Game'
      expect_content 'current-player', bard.guid, false
    end
  end

  context 'as player' do
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

    scenario 'player sees bard slot fills' do
      fool = bard.player_cards.fools.first
      crisis = bard.player_cards.crisis.first
      decision = player.player_cards.bad_decisions.first

      expect_content 'fool-blank', fool.guid, false
      expect_content 'crisis-blank', crisis.guid, false

      round.play bard, fool
      expect_content 'fool-blank', fool.guid, false

      play_card decision
      expect(page).to have_content 'can\'t'

      round.play bard, crisis
      expect_content 'fool-blank', fool.guid
      expect_content 'crisis-blank', crisis.guid
    end

    scenario 'player plays cards' do
      fool = bard.player_cards.fools.first
      crisis = bard.player_cards.crisis.first
      decision = player.player_cards.bad_decisions.first
      decision_2 = player_2.player_cards.bad_decisions.first

      round.play bard, fool
      round.play bard, crisis

      play_card decision
      expect_content 'round-player-cards', 'bad_decision'
      expect_content 'round-player-cards', decision.guid, false

      round.play player_2, decision_2
      expect_content 'round-player-cards', decision.guid
      expect_content 'round-player-cards', decision_2.guid
    end
  end
end
