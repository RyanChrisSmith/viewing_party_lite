require 'rails_helper'

RSpec.describe 'Login' do
  it 'can login a current user' do
    user = User.create!(name: 'John', email: 'john@user.com', password: 'test')
    # As a registered user
    # When I visit the landing page `/`
    visit '/'
    # I see a link for "Log In"
    expect(page).to have_link('Login')
    # When I click on "Log In"
    click_link('Login')
    # I'm taken to a Log In page ('/login') where I can input my unique email and password.
    expect(current_path).to eq(login_path)
    # When I enter my unique email and correct password
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on 'Login'
    # I'm taken to my dashboard page
    expect(current_path).to eq(users_path)
  end

  it 'can give errors when login info is incorrect' do
    user = User.create!(name: 'John', email: 'john@user.com', password: 'test')
    # As a registered user
    # When I visit the landing page `/`
    visit '/'
    # I see a link for "Log In"
    expect(page).to have_link('Login')
    # When I click on "Log In"
    click_link('Login')
    # I'm taken to a Log In page ('/login') where I can input my unique email and password.
    expect(current_path).to eq(login_path)
    # When I enter my unique email and correct password
    fill_in :email, with: 'billy@user.com'
    fill_in :password, with: user.password
    click_on 'Login'
    # I'm taken to my dashboard page
    expect(page).to have_content('Invalid Credentials')
    expect(current_path).to eq('/login')
  end

  it 'can give errors when login info is incorrect' do
    user = User.create!(name: 'John', email: 'john@user.com', password: 'test')
    # As a registered user
    # When I visit the landing page `/`
    visit '/'
    # I see a link for "Log In"
    expect(page).to have_link('Login')
    # When I click on "Log In"
    click_link('Login')
    # I'm taken to a Log In page ('/login') where I can input my unique email and password.
    expect(current_path).to eq(login_path)
    # When I enter my unique email and correct password
    fill_in :email, with: user.name
    fill_in :password, with: 'wrong password'
    click_on 'Login'
    # I'm taken to my dashboard page
    expect(page).to have_content('Invalid Credentials')
    expect(current_path).to eq('/login')
  end
end