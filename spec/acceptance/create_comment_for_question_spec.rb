require_relative 'acceptance_helper'

feature 'Create comment', '
  In order to comment the question
  As an authenticated user
  I want to be able add comment to the question
' do


  given!(:user) { create :user }
  given!(:question) { create :question, user: user }

  describe 'Authenticated user =>' do
    before { sign_in user }

    context "Creates comment for question" do
      before {visit question_path(question)}

      scenario 'User see Add Comment buttons' do
          expect(page).to have_button 'Add Comment'
      end

      scenario 'click Add Comment button', js: true do
          click_on 'Add Comment'
          expect(page).to have_selector '.new_comment'
      end

      scenario 'post comment' , js: true do
        click_on 'Add Comment'
        fill_in 'Your comment', with: 'My comment'
        click_on 'Post Comment'

        expect(page).to have_content 'My comment'
        expect(page).not_to have_selector '.new_comment'
      end

      scenario 'post invalid comment' , js: true do
        click_on 'Add Comment'
        fill_in 'Your comment', with: ''
        click_on 'Post Comment'

        expect(page).to_not have_content 'My comment'
        expect(page).to have_selector '.new_comment'
        expect(page).to have_content "can't be blank"
      end


    end
  end

  describe  'Non-authenticated user =>' do
    scenario 'does not see Add Commment buttons' do
      visit question_path(question)
      expect(page).to_not have_button 'Add Comment'
    end
  end

end