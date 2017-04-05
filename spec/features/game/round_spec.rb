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

  scenario 'user has cards'
  scenario 'user fills bard slots'
  scenario 'player sees bard slot fills'
  scenario 'player plays cards'
  scenario 'bard picks winner'
  scenario 'game reaches max score'
end
