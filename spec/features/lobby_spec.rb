require 'rails_helper'

feature 'Lobby' do
  scenario 'guest account' do
    lobby = create :lobby
    visit lobby_path lobby
    expect(page).to have_content 'Anonymous'
  end
end
