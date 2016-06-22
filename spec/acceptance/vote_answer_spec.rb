require_relative 'acceptance_helper'

feature 'Vote for answer', '
  In order to show my opinion
  As an authenticated user
  I want to be able to vote for a question or an answer
' do

   given(:user) { create(:user) }
   given!(:question) { create(:question, user: user) }
   given!(:answer) { create :answer, question: question, user: user }
   given!(:foreign_user) { create :user }
   given!(:foreign_question) { create :question, user: foreign_user }
   given!(:foreign_answer) { create :answer, question: question, user: foreign_user }


   describe 'Non-authenticated user =>' do
    scenario 'does not see vote buttons' do
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link  '+'
        expect(page).to_not have_link  '-'
        expect(page).to_not have_link 'Reset'
      end
    end
  end


  describe 'Authenticated user =>' do

    before { sign_in user }

    context "Foreign answer user haven't voted for" do
      before {visit question_path(question)}

      scenario 'User see vote buttons' do
        within '.answers' do
          expect(page).to have_link '+'
          expect(page).to have_link '-'
          expect(page).to have_link 'Reset'

          expect(page).to_not have_css("#vote_up_for_#{foreign_answer.id}.disabled")
          expect(page).to_not have_css("#vote_down_for_#{foreign_answer.id}.disabled")
          expect(page).to have_css("#vote_reset_for_#{foreign_answer.id}.disabled")
         end
      end

      scenario 'click + button', js: true do
        within "#answer_#{foreign_answer.id}" do
          click_link '+'

          within '.rating' do
            expect(page).to have_content '1'
          end

          expect(page).to have_css("#vote_up_for_#{foreign_answer.id}.disabled")
          expect(page).to have_css("#vote_down_for_#{foreign_answer.id}.disabled")
          expect(page).to_not have_css("#vote_reset_for_#{foreign_answer.id}.disabled")

        end
      end

      scenario 'click - button', js: true do
        within "#answer_#{foreign_answer.id}" do
          click_link '-'

          within '.rating' do
            expect(page).to have_content '-1'
          end

          expect(page).to have_css("#vote_up_for_#{foreign_answer.id}.disabled")
          expect(page).to have_css("#vote_down_for_#{foreign_answer.id}.disabled")
          expect(page).to_not have_css("#vote_reset_for_#{foreign_answer.id}.disabled")
        end
      end

    end

    context 'Can not vote his own answer' do
      scenario 'Can not click the vote buttons' do
        visit question_path(question)
        within "#answer_#{answer.id}" do
           expect(page).to have_css("#vote_up_for_#{answer.id}.disabled")
           expect(page).to have_css("#vote_down_for_#{answer.id}.disabled")
           expect(page).to have_css("#vote_reset_for_#{answer.id}.disabled")
        end
      end
    end


    context 'Foreign answer user has voted for' do
        let!(:vote) { create :vote, votable: foreign_answer, value: 1, user: user }
        before { visit question_path(question) }

        scenario 'Reset user vote', js: true do
          page.find("#vote_reset_for_#{foreign_answer.id}").trigger("click")

          within "#answer_#{foreign_answer.id}" do

            within '.rating' do
              expect(page).to have_content '0'
            end

            expect(page).to_not have_css("#vote_up_for_#{foreign_answer.id}.disabled")
            expect(page).to_not have_css("#vote_down_for_#{foreign_answer.id}.disabled")
            expect(page).to have_css("#vote_reset_for_#{foreign_answer.id}.disabled")

          end
        end

        scenario 'Can not vote twice for the same answer -- can not click vote buttons', js: true do
          within "#answer_#{foreign_answer.id}" do
            expect(page).to have_css("#vote_up_for_#{foreign_answer.id}.disabled")
            expect(page).to have_css("#vote_down_for_#{foreign_answer.id}.disabled")
            expect(page).to_not have_css("#vote_reset_for_#{foreign_answer.id}.disabled")
          end
        end

        scenario 'Can change his vote' , js: true do
          within "#answer_#{foreign_answer.id}" do
            expect(page).to_not have_css("#vote_reset_for_#{foreign_answer.id}.disabled")
            page.find("#vote_reset_for_#{foreign_answer.id}").trigger("click")

            click_link '-'

            within '.rating' do
              expect(page).to have_content '-1'
            end

            expect(page).to have_css("#vote_up_for_#{foreign_answer.id}.disabled")
            expect(page).to have_css("#vote_down_for_#{foreign_answer.id}.disabled")
            expect(page).to_not have_css("#vote_reset_for_#{foreign_answer.id}.disabled")
          end

        end
      end
    end

end

