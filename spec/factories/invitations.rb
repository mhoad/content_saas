FactoryGirl.define do
  factory :invitation do
    sequence(:email) { |n| "newuser#{n}@example.com" }
    association :account, :factory => :account
  end
end
