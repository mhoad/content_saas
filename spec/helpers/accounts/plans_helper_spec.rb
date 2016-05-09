require 'rails_helper'

RSpec.describe Accounts::PlansHelper, :type => :helper do
  let!(:plan) { FactoryGirl.create(:plan) }
  
  it "should convert the plan ammount to a dollar value" do
    expect(money(plan.amount)).to eq("$9.95")
  end
end
