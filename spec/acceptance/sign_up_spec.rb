require 'rails_helper'

feature 'User sign up', %q{
  In order to use a system as an authenticated user
  I want to be able to sign up
} do

  scenario 'Non-registered user tries to register with valid data' do
    visit new_user_registration_path

    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Confirm Password', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content ' Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path

  end

  scenario 'Non-registered user tries to register with existing email' do

    visit new_user_registration_path

    fill_in 'Email', with: create(:user).email
    fill_in 'Password', with: '12345678'
    fill_in 'Confirm Password', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq  user_registration_path

  end

end