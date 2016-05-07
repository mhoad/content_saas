require 'rails_helper'

RSpec.describe Account, type: :model do
  it "has a valid factory" do
    expect(build(:account)).to be_valid
  end
  
  let(:account) { FactoryGirl.create(:account) }

  it 'does not allow restricted subdomains' do
    restricted_subdomains = %w[admin help support]
    restricted_subdomains.each do |invalid_subdomain|
      account.subdomain = invalid_subdomain
      expect(account).to_not be_valid
      expect(account.errors[:subdomain]).to include("Please pick another subdomain")
    end
  end
end