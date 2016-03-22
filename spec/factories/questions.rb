FactoryGirl.define do

  sequence(:title) { |n| "Question #{n} title" }
  sequence(:content) { |n| "Question #{n} content" }

  factory :question do
    title
    content
    user

  end

  factory :invalid_question, class: 'Question' do
    title nil
    content nil
  end

end
