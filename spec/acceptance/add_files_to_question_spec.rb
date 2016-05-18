require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As a question's author
  I want to be able add files to my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'User adds file to a question while asking' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Content', with: 'text text'

      attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')
      click_on 'Save'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    scenario 'User adds several files while asking a question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Content', with: 'text text'
      all('input[type="file"]')[0].set Rails.root.join('spec', 'spec_helper.rb')
      click_on 'Add another file'
      all('input[type="file"]')[1].set Rails.root.join('spec', 'rails_helper.rb')
      click_on 'Save'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
    end
  end
end