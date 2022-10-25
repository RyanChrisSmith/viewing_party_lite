require 'rails_helper'

RSpec.describe 'User registration form' do
  it 'registers a new user' do
    visit root_path
    click_on "Register as a User"
    # As a visitor
    # When I visit `/register`
    expect(current_path).to eq(new_users_path)

    name = "Happy"
    email = "happy@me.com"
    password = "test"
    # I see a form to fill in my name, email, password, and password confirmation.
    fill_in :name, with: name
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password
    # When I fill in that form with my name, email, and matching passwords,
    click_on "Submit"
    # I'm taken to my dashboard page `/users/:id`
    expect(current_path).to eq(users_path)

    expect(page).to have_content("Welcome #{name}")
  end

  describe 'will reroute back to register page if all fields are not filled out' do
    before :each do
      visit root_path
      click_on "Register as a User"
      @name = "Happy"
      @email = "happy@me.com"
      @password = "test"
    end

    it 'returns me to the registration form and error for blank name' do
      fill_in :email, with: @email
      fill_in :password, with: @password
      fill_in :password_confirmation, with: @password
      click_on "Submit"
      expect(current_path).to eq('/register')
      expect(page).to have_content("Name can't be blank")
    end

    it 'returns me to the registration form and error for blank email' do
      fill_in :name, with: @name
      fill_in :password, with: @password
      fill_in :password_confirmation, with: @password
      click_on "Submit"
      expect(current_path).to eq('/register')
      expect(page).to have_content("Email can't be blank")
    end

    it 'returns me to the registration form and error for blank password' do
      fill_in :name, with: @name
      fill_in :email, with: @email
      click_on "Submit"
      expect(current_path).to eq('/register')
      expect(page).to have_content("Password can't be blank")
    end

    it 'returns me to the registration form and error for non-matching passwords' do
      fill_in :name, with: @name
      fill_in :email, with: @email
      fill_in :password, with: @password
      fill_in :password_confirmation, with: 'nottest'
      click_on "Submit"
      expect(current_path).to eq('/register')
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end