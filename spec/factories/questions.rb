FactoryGirl.define do
  factory :question do
    title 'My String'
    content 'My Text'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    content nil

  end

end
