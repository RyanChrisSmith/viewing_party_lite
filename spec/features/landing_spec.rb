require 'rails_helper'

RSpec.describe 'Landing Page' do
  describe 'when a user visits the root path' do
    it 'displays the title of the app, existing users, with links to users dashboard' do

      visit root_path

      expect(page).to have_content('Viewing Party Lite')
      expect(page).to have_link('Register as a User')
      expect(page).to have_link('Home')
    end
  end

  describe 'logged in view' do
    before :each do
      @user = User.create!(name: 'John', email: 'john@user.com', password: 'test')
      visit login_path
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_on 'Login'
    end
    it 'will show a log out link only once logged in' do
      # As a logged in user
      # When I visit the landing page
      visit root_path
      # I no longer see a link to Log In or Create an Account
      expect(page).to_not have_content('Login')
      expect(page).to_not have_content('Register as a User')
      # But I see a link to Log Out.
      expect(page).to have_content('Logout')
      # When I click the link to Log Out
      click_link('Logout')
      # I'm taken to the landing page
      expect(current_path).to eq(root_path)
      # And I can see that the Log Out link has changed back to a Log In link
      expect(page).to have_content('Login')
      expect(page).to have_content('Register as a User')
      expect(page).to_not have_content('Logout')
    end
  end
end
