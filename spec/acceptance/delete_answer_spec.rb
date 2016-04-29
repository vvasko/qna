require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to delete an answer
  As an authenticated user and an author of an answer
  I want to be able to delete an answer
} do

  given(:user) { create(:user) }
  given!(:foreign_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:foreign_answer) { create(:answer, question: question, user: foreign_user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Does not see Delete link for foreign answers', js: true do
      within "#answer_#{foreign_answer.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end

    scenario 'sees link Delete for his answers' do
      within "#answer_#{answer.id}" do
        expect(page).to have_link 'Delete'
      end
    end

    scenario 'tries to delete his answer', js: true do
      within "#answer_#{answer.id}"  do
        click_on 'Delete'
      end
      expect(page).to_not have_selector(:css,"#answer_#{answer.id}")
    end
  end

  describe 'Non-authenticated user' do
    scenario 'does not see the Delete link' do
      visit question_path question
      expect(page).to_not have_link 'Delete'
    end
  end

end