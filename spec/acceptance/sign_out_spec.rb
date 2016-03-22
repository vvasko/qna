require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to finish work with a system
  As an authenticated user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)
    click_on 'Log Out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

end
