require_relative 'acceptance_helper'


feature 'Question editing', %q{
  In order to fix a mistake
  As an author of a question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:foreign_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:foreign_question) { create(:question, user: foreign_user) }

  describe 'Authenticated user' do
    before do
      sign_in user
    end

    scenario 'tries to edit other user`s question.', js: true do
      visit question_path(foreign_question)

      within "#question_#{foreign_question.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end


    scenario 'tries to edit his question.', js: true do
      visit question_path(question)
      click_on 'Edit'
      within "#question_#{question.id}" do

        fill_in 'Title', with: 'edited title'
        fill_in 'Content', with: 'edited content'
        click_on 'Save'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.content
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited content'
        expect(page).to_not have_selector 'textarea'
      end
    end


  end

  describe 'Non-authenticated user' do
    scenario 'does not see the Edit link' do
      visit question_path question
      expect(page).to_not have_link 'Edit'
    end
  end


end