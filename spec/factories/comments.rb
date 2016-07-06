FactoryGirl.define do
  factory :comment do
    content
    user
  end

  factory :invalid_comment, class: "Comment" do
    content nil
  end
end