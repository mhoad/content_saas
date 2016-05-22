FactoryGirl.define do
  factory :invitation do
  	email { Faker::Internet.email }
    association :account, :factory => :account
  end
end
