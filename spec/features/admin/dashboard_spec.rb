require 'rails_helper'

feature 'Admin Dashboard' do
  let!(:admin) { create :user, :admin }

  context 'when not signed in' do
    scenario 'user visits dashboard' do
      visit(admin_dashboard_path)
      expect(page).to have_content 'Log In'

      fill_in :user_username, with: admin.username
      fill_in :user_password, with: 'fishsticks'
      click_button 'Log In'

      expect(page).to have_content 'Dashboard'
    end
  end

  context 'when signed in' do
    before { sign_in admin }

    context 'as non-admin' do
      let(:user) { create :user }
      before { sign_in user }

      scenario 'user visits dashboard', js: true do
        visit(admin_dashboard_path)
        expect(page).to have_content 'Game Lobbies'
        expect(page).to have_content 'permissions'
      end
    end

    scenario 'user visits dashboard' do
      visit(admin_dashboard_path)
      expect(page).to have_content 'Dashboard'
    end
  end
end
