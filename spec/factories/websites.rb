FactoryGirl.define do
  factory :website do
    url "http://www.#{Faker::Internet.domain_name}/"
    association :account, :factory => [:account, :subscribed]
    
    trait :no_account do
      account nil
    end
  end
end
