FactoryGirl.define do
  factory :website do
    url "http://www.website.com/"
    association :account, :factory => :account
  end
end
