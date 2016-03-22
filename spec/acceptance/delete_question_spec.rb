require 'rails_helper'

feature 'Delete question', %q{
  In order to delete question
  As an authenticated user and an author of a question
  I want to be able to delete question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:foreign_question) { create(:question) }

  scenario 'Authenticated user deletes his question' do
    sign_in(user)

    visit questions_path
    click_on question.title

    within '.question' do
      click_on 'Delete'
    end

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user deletes foreign question' do
    sign_in(user)
    visit question_path(foreign_question)

    expect(page).to_not have_content 'Delete'
  end


end