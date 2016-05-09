FactoryGirl.define do
  factory :plan do
    name "Starter"
    amount 995
    stripe_id "starter"
    websites_allowed 2
  end
end