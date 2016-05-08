require 'rails_helper'

RSpec.describe InvitationEmailJob, :type => :job do
  describe InvitationEmailJob, job: true do
    describe "#perform" do
      let(:invitation) { FactoryGirl.create(:invitation) }

      it "delivers an invitation email" do
        expect {
          InvitationEmailJob.new.perform(invitation.id)
        }.to change{ ActionMailer::Base.deliveries.size }.by(1)
      end
      
    end
  end
end
