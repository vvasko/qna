require 'rails_helper'

feature 'Create question', %q{
  In order to get an answer from comunity
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates a question' do

    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Content', with: 'text text'

    click_on 'Save'

    expect(page).to have_content 'Question created successfully.'

  end

  scenario 'Non-authenticated user creates a question' do
    visit questions_path
    expect(page).to_not have_content 'Ask question'

  end

  scenario 'Non-authenticated user creates a question' do
    visit new_question_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'

  end


end