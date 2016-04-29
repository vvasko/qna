require_relative 'acceptance_helper'

feature 'Show question', %q{
    I want to be able to view the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  let(:answers) { create_list :answer, 3,  user: user,  question: question }

  scenario 'User can see the question details' do
    answers
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.content

    answers.each { |answer|
      expect(page).to have_content answer.content
    }

  end

end