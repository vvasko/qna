require_relative 'acceptance_helper'

feature 'Delete comment from question', %q{
  In order to delete comment from question
  As an author of a comment
  I want to be able to delete comment
} do


  given!(:user) { create :user }
  given!(:question) { create :question }
  given!(:comment) { create :comment, commentable: question, user: user }
  given!(:foreign_comment) { create :comment, commentable: question }


  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can see trash button' do
      expect(page).to have_css 'a[class="glyphicon glyphicon-trash"]'
    end

    scenario ' deletes his own comment', js: true do
      within "#comment_#{comment.id}" do
        page.find(:css, 'a[class="glyphicon glyphicon-trash"]').click
        expect(page).to_not have_content comment
      end
    end

    scenario 'can not see trash button for foreign comment' do
      within "#comment_#{foreign_comment.id}" do
        expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
      end
    end
  end


  describe 'Non-authenticated user tries to delete comment' do
    scenario 'can not see trash button' do
      visit question_path(question)
      expect(page).to_not have_css 'a[class="glyphicon glyphicon-trash"]'
    end
  end

end