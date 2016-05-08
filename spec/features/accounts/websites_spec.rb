require "rails_helper"

feature "Books" do
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  before do
    FactoryGirl.create(:website, url: "http://www.account-a.com/", account: account_a)
    FactoryGirl.create(:website, url: "http://www.account-b.com", account: account_b)
  end

  context "index" do
    scenario "displays only account A's website" do
      set_subdomain(account_a.subdomain)
      login_as(account_a.owner)
      visit root_url
      expect(page).to have_content("http://www.account-a.com/")
      expect(page).to_not have_content("http://www.account-b.com")
    end

    scenario "displays only account B's book" do
      set_subdomain(account_b.subdomain)
      login_as(account_b.owner)
      visit root_url
      expect(page).to have_content("http://www.account-b.com")
      expect(page).to_not have_content("http://www.account-a.com/")
    end
  end
  
  context "show" do
    context "when signed in as account A's owner" do
      before do
        login_as(account_a.owner)
        set_subdomain(account_a.subdomain)
      end

      it "can see Account A's website" do
        website = account_a.websites.first
        visit website_url(website)
        expect(page).to have_content(website.url)
      end

      it "cannot see Account B's website" do
        website = account_b.websites.first
        visit website_url(website)
        expect(page).to have_content('The website you were looking for cannot be found.')
        expect(page.current_url).to eq(root_url)
      end
    end
  end
end