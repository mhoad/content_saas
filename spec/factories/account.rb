FactoryGirl.define do
  factory :account do
    sequence(:name) { |n| "Test Account #{n}" }
    sequence(:subdomain) { |n| "test#{n}" }
    association :owner, :factory => :user
    
    trait :subscribed do
      stripe_customer_id "123ABC"
      stripe_subscription_id "ABC123"
      stripe_subscription_status "active"
      association :plan, :factory => :plan      
    end

    trait :unpaid_subscriber do
      stripe_customer_id "123ABC"
      stripe_subscription_id "ABC123"
      stripe_subscription_status "unpaid"
      association :plan, :factory => :plan
    end
  end
end