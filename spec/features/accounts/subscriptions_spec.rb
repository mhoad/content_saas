require "rails_helper"

feature "Subscriptions" do
  let(:customer) do
    Stripe::Customer.create(
      source: {
        object: "card",
        number: "4242424242424242",
        exp_month: Time.now.month,
        exp_year: Time.now.year + 1,
        cvc: "123"
      }
    )
  end
  let(:plan) { FactoryGirl.create(:plan) }
  let(:account) { FactoryGirl.create(:account) }
 
  before do 
    subscription = customer.subscriptions.create(plan: plan.stripe_id)
    account.stripe_customer_id = customer.id
    account.stripe_subscription_id = subscription.id
    account.stripe_subscription_status = "active" 
    account.save

    set_subdomain(account.subdomain)
    login_as(account.owner)
  end

  scenario "can be cancelled" do
    old_subscription_id = account.stripe_subscription_id
 
    visit root_url
    click_link "Change Plan"
    click_link "Cancel your subscription"
    within(".alert") do
      expect(page).to have_content("Your subscription has been cancelled.")
    end

    account.reload
    
    expect(account.stripe_subscription_id).to be_blank
    active_subscriptions = customer.subscriptions.all
    expect(active_subscriptions.count).to eq(0)
  end
  
  scenario "can be updated" do
    silver_plan = Plan.create(
      name: "Silver",
      stripe_id: "silver",
      amount: 1500,
      websites_allowed: 3)

    visit root_url
    click_link "Change Plan"
    click_button "choose_silver"

    customer = Stripe::Customer.retrieve(account.stripe_customer_id)
    subscription = customer.subscriptions.retrieve(account.stripe_subscription_id)
    expect(subscription.plan.id).to eq(silver_plan.stripe_id)

    account.reload
    expect(account.plan).to eq(silver_plan)

    within(".alert") do
      expect(page).to have_content("You have changed to the Silver plan.")
    end
  end
  
  scenario "is prompted to upgrade plan when over limit" do
    starter_plan = Plan.create!(
      name: "Starter",
      stripe_id: "starter",
      websites_allowed: 1,
    )

    silver_plan = Plan.create!(
      name: "Silver",
      stripe_id: "silver",
      websites_allowed: 3
    )

    account.plan = starter_plan
 
    account.websites << FactoryGirl.create(:website, :no_account)
    account.save

    visit root_url
    click_link "Add Website"

    within(".alert") do
      message = "You have reached your plan's limit." + 
        " You need to upgrade your plan to add more websites."
      expect(page).to have_content(message)
    end

    click_button "choose_silver"

    within(".alert") do
      expect(page).to have_content("You have changed to the Silver plan.")
    end

    expect(page.current_url).to eq(new_website_url)
  end
end