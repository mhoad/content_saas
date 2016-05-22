require "rails_helper"

RSpec.feature "Unpaid subscriptions" do

  let(:unpaid_account) { FactoryGirl.create(:account, :unpaid_subscriber) }
  let(:website) { FactoryGirl.create(:website, account: unpaid_account) }
  
 
  context "a user for the account" do
    let(:regular_user) { FactoryGirl.create(:user) }

    before do
      unpaid_account.users << regular_user
      login_as(regular_user)
      set_subdomain(unpaid_account.subdomain)
    end

    it 'cannot access the accounts websites' do
      visit website_path(website)
      expect(page.current_url).to eq(root_url)
      expect(page).to have_content("This account is currently disabled due to an unpaid subscription.")
      expect(page).to have_content("Please contact the account owner.")
    end
  end

  context 'the owner of the account' do
    before do
      login_as(unpaid_account.owner)
      set_subdomain(unpaid_account.subdomain)
    end

    it 'cannot add a new website to the account' do
      visit new_website_path
      expect(page.current_url).to eq(root_url)
      expect(page).to have_content("This account is currently disabled due to an unpaid subscription.")
      expect(page).to have_content("Please update your payment details to re-activate your subscription.")
    end
  end
  

end