class InvitationEmailJob < ApplicationJob
  queue_as :default

  def perform(invitation_id)
    invitation = Invitation.find(invitation_id)
    InvitationMailer.invite(invitation).deliver_now
  end
end
