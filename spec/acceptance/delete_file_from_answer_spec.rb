require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to update my question
  As a question's author
  I want to be able to delete files from my question
} do


  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:foreign_user) { create(:user) }
  given!(:foreign_question) { create(:question, user: foreign_user) }

  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:foreign_answer) { create(:answer, question: question, user: foreign_user) }

  given!(:attachment) { create(:attachment, attachable: answer) }
  given!(:foreign_attachment) { create(:attachment, attachable: foreign_answer) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User deletes file from his answer', js: true do
      within "#answer_#{answer.id}" do
        within('.attachment_list') do
          click_on 'Delete'
        end
        expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end

    end

    scenario 'User deletes file from foreign answer' do
      visit question_path(question)
      within "#answer_#{foreign_answer.id}" do
        within('.attachment_list') do
          expect(page).to_not have_link 'Delete'
        end
      end
    end

  end


end