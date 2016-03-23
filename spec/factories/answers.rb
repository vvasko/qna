FactoryGirl.define do
    factory :answer do
    sequence(:content) { |n| "Answer content#{n}"}
    question
    user
  end

    factory :invalid_answer do
      content nil
      question_id nil
    end

end


