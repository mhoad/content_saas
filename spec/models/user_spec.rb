require 'rails_helper'

RSpec.describe User, :type => :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end
  
  let(:user) { FactoryGirl.create(:user) }
  
  it "doesn't allow short passwords" do
    user.password = "1234"
    expect(user).to_not be_valid
  end
end