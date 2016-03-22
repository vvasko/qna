require 'rails_helper'

feature 'Show question', %q{
    I want to be able to view the question
} do

  given!(:question) { create(:question) }

  scenario 'User can see the question details' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.content

  end

end