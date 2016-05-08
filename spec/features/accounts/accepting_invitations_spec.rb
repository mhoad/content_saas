require 'rails_helper'

feature "Accepting invitations" do
  let(:invitation) { FactoryGirl.create(:invitation) }

  before do
    InvitationMailer.invite(invitation).deliver_now
    set_default_host
  end

  scenario "accepts an invitation" do
    open_email(invitation.email)
    accept_link = links_in_email(current_email).first
    expect(accept_link).to be_present
    
    visit accept_link
    
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"
    click_button "Accept Invitation"
    
    expect(User.where(email: invitation.email)).to exist
    expect(page).to have_content("You have joined the #{invitation.account.name} account.")
    expect(page.current_url).to eq(root_url(subdomain: invitation.account.subdomain))
  end
  
  scenario "gracefully handles user sign-up error" do
    open_email(invitation.email)
    accept_link = links_in_email(current_email).first
    expect(accept_link).to be_present
    
    visit accept_link
    
    fill_in "user[password]", with: "1234"
    fill_in "user[password_confirmation]", with: "1234"
    click_button "Accept Invitation"
    
    expect(User.where(email: invitation.email)).not_to exist
    expect(page).to have_content("There was an error creating your account.")
    expect(page.current_url).to eq(accept_invitation_url(id: invitation.token, subdomain: invitation.account.subdomain))
  end
  
  scenario "accepts an invitation as an existing user" do
    InvitationMailer.invite(invitation).deliver_now
    
    set_subdomain(invitation.account.subdomain)
    open_email(invitation.email)
    accept_link = links_in_email(current_email).first
    expect(accept_link).to be_present

    visit accept_link
    click_link "Sign in as an existing user"
    user = FactoryGirl.create(:user)
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    invitation_url = accept_invitation_url(invitation, subdomain: invitation.account.subdomain)
    expect(page.current_url).to eq(invitation_url)
    expect(page).to_not have_content("Sign in as an existing user")
    click_button "Accept Invitation"
    expect(page).to have_content("You have joined the #{invitation.account.name} account.")
    expect(page.current_url).to eq(root_url)
  end
end