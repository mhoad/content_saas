require 'rails_helper'

feature "Accepting invitations" do
  let(:account) { FactoryGirl.create(:account) }
  let(:invitation) do
    Invitation.create(
      account: account, 
      email: "new_user@example.com"
    )
  end
  let(:second_invitation) do
    Invitation.create(
      account: account, 
      email: "another_user@example.com"
    )
  end

  before do
    set_default_host
  end

  scenario "accepts an invitation" do
    InvitationMailer.invite(invitation).deliver_now
    
    open_last_email_for("new_user@example.com")
    accept_link = links_in_email(current_email).first
    expect(accept_link).to be_present
    
    visit accept_link
    
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"
    click_button "Accept Invitation"
    
    expect(User.where(email: "new_user@example.com")).to exist
    expect(page).to have_content("You have joined the #{account.name} account.")
    expect(page.current_url).to eq(root_url(subdomain: account.subdomain))
  end
  
  scenario "gracefully handles user sign-up error" do
    InvitationMailer.invite(second_invitation).deliver_now
    
    open_last_email_for("another_user@example.com")
    accept_link = links_in_email(current_email).first
    expect(accept_link).to be_present
    
    visit accept_link
    
    fill_in "user[password]", with: "1234"
    fill_in "user[password_confirmation]", with: "1234"
    click_button "Accept Invitation"
    
    expect(User.where(email: "another_user@example.com")).not_to exist
    expect(page).to have_content("There was an error creating your account.")
    expect(page.current_url).to eq(accept_invitation_url(id: second_invitation.token, subdomain: account.subdomain))
  end
end