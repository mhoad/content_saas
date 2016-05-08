require 'rails_helper'

feature "Accepting invitations" do
  let(:account) { FactoryGirl.create(:account) }
  let(:invitation) do
    Invitation.create(
      account: account, 
      email: "newuser@example.com"
    )
  end

  before do
    InvitationMailer.invite(invitation).deliver_now
    set_default_host
    
    open_last_email_for("newuser@example.com")
    accept_link = links_in_email(current_email).first
    expect(accept_link).to be_present
    
    visit accept_link
  end

  scenario "accepts an invitation" do
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"
    click_button "Accept Invitation"
    
    expect(User.where(email: "newuser@example.com")).to exist
    expect(page).to have_content("You have joined the #{account.name} account.")
    expect(page.current_url).to eq(root_url(subdomain: account.subdomain))
  end
  
  scenario "gracefully handles user sign-up error" do
    fill_in "user[password]", with: "1234"
    fill_in "user[password_confirmation]", with: "1234"
    click_button "Accept Invitation"
    
    expect(User.where(email: "newuser@example.com")).not_to exist
    expect(page).to have_content("There was an error creating your account.")
    expect(page.current_url).to eq(accept_invitation_url(id: invitation.id, subdomain: account.subdomain))
  end
end