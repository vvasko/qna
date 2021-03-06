require_relative 'acceptance_helper'

feature 'Create answer', %q{
  In order to help anther user
  As an authenticated user
  I want to be able to post an answer to the questions
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'answer_content', with: 'Test Answer'
    click_on 'Post Your Answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Test Answer'
    end
  end

  scenario 'Authenticated user creates invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Post Your Answer'

    expect(page).to have_content "Content can't be blank"

  end

  scenario 'Non-authenticated user creates an answer', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Post Your Answer'
  end
end