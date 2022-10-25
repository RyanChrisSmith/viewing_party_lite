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

    it 'will show a list of existing users once logged in' do
      # As a visitor
      users = create_list(:random_user, 6)
      # When I visit the landing page
      visit root_path
      user_1 = users[0]
      user_2 = users[1]
      expect(page).to have_content(user_1.email)
      expect(page).to have_content(user_2.email)
      # I do see the section of the page that lists existing users
    end
  end

  it 'will not show a list of existing users when not logged in' do
    # As a visitor
    users = create_list(:random_user, 6)
    # When I visit the landing page
    visit root_path
    user_1 = users[0]
    user_2 = users[1]
    expect(page).to_not have_content(user_1.email)
    expect(page).to_not have_content(user_2.email)
    # I do NOT see the section of the page that lists existing users
  end

  it 'shows that you must be logged in or registered to access the dashboard' do
    # As a visitor
    # When I visit the landing page
    visit root_path
    # And then try to visit '/dashboard'
    visit users_path
    # I remain on the landing page
    expect(current_path).to eq(root_path)
    # And I see a message telling me that I must be logged in or registered to access my dashboard
    expect(page).to have_content("You will need be registered and then logged in to access that page")
  end

  describe 'will not let you create a viewing party without being registered or logged in' do
    it 'will error out if not registered or logged in', :vcr do
      @movie = MoviesFacade.movie_details(238)
      # As a visitor
      # If I go to a movies show page
      visit movie_path(@movie.id)
      # And click the button to create a viewing party
      click_button('Create Viewing Party')
      # I'm redirected to the movies show page, and a message appears to let me know I must be logged in or registered to create a movie party.
      expect(current_path).to eq(movie_path(@movie.id))
      expect(page).to have_content("You will need be registered and then logged in to access that page")
    end
  end
end
