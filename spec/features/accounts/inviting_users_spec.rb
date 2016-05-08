require 'rails_helper'

feature "Inviting Users" do
  include ActiveJob::TestHelper
  
  let(:account) { FactoryGirl.create(:account) }
  
  before do
    set_subdomain(account.subdomain)
    login_as(account.owner)
    visit root_url
    
    #Make sure there are no old jobs in the ActiveJobs queue
    clear_enqueued_jobs 
  end
  
  scenario "invites a user successfully" do
    click_link "Users"
    click_link "Invite User"
    
    fill_in "Email", with: "test@example.com"
    click_button "Invite User"
    
    #Make sure it gets added to the job queue and then execute the job
    expect(enqueued_jobs.size).to eq(1)
    invitation_id = enqueued_jobs.first[:args].first
    perform_enqueued_jobs { InvitationEmailJob.perform_now(invitation_id) }
    
    
    expect(page).to have_content("test@example.com has been invited.")
    expect(page.current_url).to eq(root_url)
    
    email = find_email("test@example.com")
    expect(email).to be_present
    
    expect(email.subject).to eq("Invitation to join #{account.name}")
  end
end