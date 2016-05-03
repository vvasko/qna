require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As a question's author
  I want to be able add files to my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file to a question while asking' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Content', with: 'text text'

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1'
  end
end