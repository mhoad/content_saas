FactoryGirl.define do
  factory :invitation do
    email "test@example.com"
    #account nil
    association :account, :factory => :account
  end
end
