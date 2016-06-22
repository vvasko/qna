require_relative 'acceptance_helper'

feature 'Vote for question', '
  In order to show my opinion
  As an authenticated user
  I want to be able to vote for a question or an answer
' do

  given!(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:foreign_user) { create :user }
  given!(:foreign_question) { create :question, user: foreign_user }


  describe 'Authenticated user =>' do
    before { sign_in user }
    context "Foreign question user haven't voted for" do
      before { visit questions_path }

      scenario 'User see vote buttons' do
        within '.questions_list' do
          expect(page).to have_link '+'
          expect(page).to have_link '-'
          expect(page).to have_link 'Reset'

          expect(page).to_not have_css("#vote_up_for_#{foreign_question.id}.disabled")
          expect(page).to_not have_css("#vote_down_for_#{foreign_question.id}.disabled")
          expect(page).to have_css("#vote_reset_for_#{foreign_question.id}.disabled")

        end
      end

      scenario 'click + button', js: true do
        within "#question_#{foreign_question.id}" do
          click_link '+'

          within '.rating' do
            expect(page).to have_content '1'
          end

          expect(page).to have_css("#vote_up_for_#{foreign_question.id}.disabled")
          expect(page).to have_css("#vote_down_for_#{foreign_question.id}.disabled")
          expect(page).to_not have_css("#vote_reset_for_#{foreign_question.id}.disabled")

        end
      end

      scenario 'click - button', js: true do
        within "#question_#{foreign_question.id}" do
          click_link '-'

          within '.rating' do
            expect(page).to have_content '-1'
          end

          expect(page).to have_css("#vote_up_for_#{foreign_question.id}.disabled")
          expect(page).to have_css("#vote_down_for_#{foreign_question.id}.disabled")
          expect(page).to_not have_css("#vote_reset_for_#{foreign_question.id}.disabled")
        end
      end
    end

    context 'Can not vote his own question' do
      scenario 'Can not click the vote buttons' do
        visit questions_path
        within "#question_#{question.id}" do
           expect(page).to have_css("#vote_up_for_#{question.id}.disabled")
           expect(page).to have_css("#vote_down_for_#{question.id}.disabled")
           expect(page).to have_css("#vote_reset_for_#{question.id}.disabled")
        end
      end
    end


    context 'Foreign question user has voted for' do
      given!(:vote) { create :vote, votable: foreign_question, value: 1, user: user }
      before { visit questions_path }

      scenario 'Reset user vote', js: true do
        page.find("#vote_reset_for_#{foreign_question.id}").trigger("click")

        within "#question_#{foreign_question.id}" do
          within '.rating' do
            expect(page).to have_content '0'
          end

          expect(page).to_not have_css("#vote_up_for_#{foreign_question.id}.disabled")
          expect(page).to_not have_css("#vote_down_for_#{foreign_question.id}.disabled")
          expect(page).to have_css("#vote_reset_for_#{foreign_question.id}.disabled")

        end
      end

      scenario 'Can not vote twice for the same question -- can not click vote buttons', js: true do
        within "#question_#{foreign_question.id}" do
          expect(page).to have_css("#vote_up_for_#{foreign_question.id}.disabled")
          expect(page).to have_css("#vote_down_for_#{foreign_question.id}.disabled")
          expect(page).to_not have_css("#vote_reset_for_#{foreign_question.id}.disabled")
        end
      end

      scenario 'Can change his vote' , js: true do
        within "#question_#{foreign_question.id}" do
          expect(page).to_not have_css("#vote_reset_for_#{foreign_question.id}.disabled")
          page.find("#vote_reset_for_#{foreign_question.id}").trigger("click")

          click_link '-'

          within '.rating' do
            expect(page).to have_content '-1'
          end

          expect(page).to have_css("#vote_up_for_#{foreign_question.id}.disabled")
          expect(page).to have_css("#vote_down_for_#{foreign_question.id}.disabled")
          expect(page).to_not have_css("#vote_reset_for_#{foreign_question.id}.disabled")
        end

      end
    end
  end


  describe 'Non-authenticated user =>' do
    scenario 'does not see vote buttons', js: true do
      visit questions_path
      within '.questions_list' do
        expect(page).to_not have_link  '+'
        expect(page).to_not have_link  '-'
        expect(page).to_not have_link 'Reset'
      end
    end
  end

end

