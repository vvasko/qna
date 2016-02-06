FactoryGirl.define do
  factory :answer do
      content 'My Text'
      question
    end

    factory :invalid_answer do
      content nil
      question_id nil
    end

end


