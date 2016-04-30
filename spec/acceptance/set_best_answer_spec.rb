require_relative 'acceptance_helper'

feature 'Chosing the best answer', %q{
  In order to show the best answer to another users
  As an author of a question
  I'd like ot be able to chose the best answer
} do

  given(:user) { create(:user) }
  given!(:foreign_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:foreign_question) { create(:question, user: foreign_user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
    end

    scenario 'Does not see Chose as Best link for foreign questions', js: true do
      visit question_path(foreign_question)
      within ".answers" do
        expect(page).to_not have_link 'Chose as Best'
      end
    end

    scenario 'sees link to Chose as Best for his question' do
      visit question_path(question)
      within ".answers" do
        expect(page).to have_link 'Chose as Best'
      end
    end

    scenario 'choses the best answer', js: true do
      visit question_path(question)
      within "#answer_#{answer.id}"  do
        click_on 'Chose as Best'
        expect(page).to have_content answer.content
        expect(page).to_not have_link 'Chose as Best'
      end
    end

    describe 'The best answer is chosen' do
      before do
         another_answer.set_best!
         visit question_path(question)
      end
      scenario 'is choosing another best answer after existing', js: true do
        within "#answer_#{answer.id}"  do
          click_on 'Chose as Best'
          expect(page).to_not have_link 'Chose as Best'
        end
        within "#answer_#{another_answer.id}" do
          expect(page).to have_link 'Chose as Best'
        end
      end
    end
  end

  describe 'Any user' do
    scenario 'sees the best answer at the top of answers list ' do
      visit question_path(question)
      answer.set_best!
      expect(first('.answers')).to have_content answer.content
    end
  end

  describe 'Non-authenticated user' do
    scenario 'does not see the  Chose as Best link' do
      visit question_path(question)
      expect(page).to_not have_link 'Chose as Best'
    end
  end


end




