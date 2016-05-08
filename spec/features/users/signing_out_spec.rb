require 'rails_helper'

describe 'signing out' do
  let(:user) { FactoryGirl.create(:user) }
  before do
    login_as(user)
    visit root_path
  end
  
  it "can sign out" do
    click_link "Sign out"
    expect(page).to have_content("Signed out successfully.")
  end
end