require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As a answer's author
  I want to be able add files to my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User adds file to the answer while answering a question', js:true do
      fill_in 'answer_content', with: 'Test Answer'
      attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_content 'Test Answer'
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end

    scenario 'User adds several files while answering a question', js: true do
      fill_in 'answer_content', with: 'Test Answer with many files'
      all('input[type="file"]')[0].set Rails.root.join('spec', 'spec_helper.rb')
      click_on 'Add another file'
      all('input[type="file"]')[1].set Rails.root.join('spec', 'rails_helper.rb')
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_content 'Test Answer with many files'
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end
  end
end