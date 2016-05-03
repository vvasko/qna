require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As a answer's author
  I want to be able add files to my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to the answer while answering a question', js:true do
    fill_in 'answer_content', with: 'Test Answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1'
    end
  end
end