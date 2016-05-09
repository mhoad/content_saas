require 'rails_helper'

feature 'Accounts' do

  let!(:plan) { FactoryGirl.create(:plan) }

  scenario "creating an account" do
    visit root_path
    click_link "Create a new account"
    
    fill_in "Name", with: "Test"
    fill_in "Subdomain", with: "test"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    
    click_button "Next"
    
    account = Account.last
    expect(account.stripe_customer_id).to be_present
    
    
    set_subdomain("test")
    expect(page.current_url).to eq(choose_plan_url(subdomain: "test"))
    
    choose plan.name
    click_button "Finish"
    
    within(".alert") do
      success_message = "Your account has been successfully created."
      expect(page).to have_content(success_message)
    end
    
    account.reload
    expect(account.plan).to eq(plan)
    
    expect(page).to have_content("Signed in as test@example.com")
    expect(page.current_url).to eq("http://test.lvh.me/")
  end
  
  scenario "Ensure subdomain uniqueness" do
    Account.create!(subdomain: "test", name: "Test")
    
    visit root_path
    click_link "Create a new account"
    
    fill_in "Name", with: "Test"
    fill_in "Subdomain", with: "test"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    
    click_button "Next"
    
    expect(page.current_url).to eq("http://lvh.me/accounts")
    expect(page).to have_content("Sorry, your account could not be created.")
    
    #Tells the user that the subdomain has already been taken
    subdomain_error = find('.account_subdomain .help-block').text
    expect(subdomain_error).to eq('has already been taken')
  end
end