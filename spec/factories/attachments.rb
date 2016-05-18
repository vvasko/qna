FactoryGirl.define do
    factory :attachment do
      file File.open(Rails.root.join('spec', 'spec_helper.rb'))
    end
end


