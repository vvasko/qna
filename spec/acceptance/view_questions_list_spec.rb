require_relative 'acceptance_helper'

feature 'View questions list', %q{
  In order to be able to browse questions
    I want to be able to view list of questions
} do

  given!(:questions) { create_list(:question, 2) }

  scenario 'View questions list' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end

  end
end