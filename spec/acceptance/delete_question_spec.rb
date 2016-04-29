require_relative 'acceptance_helper'

feature 'Delete question', %q{
  In order to delete question
  As an authenticated user and an author of a question
  I want to be able to delete question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:foreign_question) { create(:question) }


  describe 'Authenticated user' do
    before do
      sign_in(user)
    end

    scenario 'deletes his question' do
      visit questions_path
      click_on question.title

      within '.question' do
        click_on 'Delete'
      end

      expect(current_path).to eq questions_path
      expect(page).to_not have_content question.title
    end

    scenario 'deletes foreign question' do
      visit question_path(foreign_question)
      expect(page).to_not have_content 'Delete'
    end
  end

  describe 'Non-authenticated user' do
    scenario 'does not see the Delete link' do
      visit questions_path
      click_on question.title

      expect(page).to_not have_content 'Delete'
    end
  end

end