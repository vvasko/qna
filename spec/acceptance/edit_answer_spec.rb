require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like ot be able to edit my answer
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

    scenario 'Does not see Edit link for foreign answers', js: true do
      within "#answer_#{foreign_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'sees link to Edit for his answers' do
      within "#answer_#{answer.id}" do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his answer', js: true do
      within "#answer_#{answer.id}"  do
        click_on 'Edit'
        fill_in 'answer_content', with: 'Edited Answer'
        click_on 'Save'

        expect(page).to_not have_content answer.content
        expect(page).to have_content 'Edited Answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  describe 'Non-authenticated user' do
    scenario 'does not see the Edit link' do
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end
end




