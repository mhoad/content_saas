FactoryGirl.define do
  factory :website do
    url "http://www.website.com/"
    # association :account, factory: :account, :subscribed
    # association :account, factory: :account, trait: :subscribed
    association :account, :factory => [:account, :subscribed]
  end
end
