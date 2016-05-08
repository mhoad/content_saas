require 'rails_helper'

feature "Deleting websites" do
  let(:website) { FactoryGirl.create(:website) }
  
  context "as the account owner" do
    before do
      login_as(website.account.owner)
      set_subdomain(website.account.subdomain)
      visit root_url
    end
    
    it "can remove a website" do
      click_link "Edit"
      fill_in "Url", with: "http://www.google.com/" 
      click_button "Update"
      expect(page).to have_content("Website successfully updated.")
    end
  end
  
  context "as a regular user" do
    it "cannot remove a website" do
      #pending test
    end
  end
end