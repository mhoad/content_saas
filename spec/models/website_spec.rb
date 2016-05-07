require 'rails_helper'

RSpec.describe Website, :type => :model do
  it "has a valid factory" do
    # Using the shortened version of FactoryGirl syntax.
    expect(build(:website)).to be_valid
  end
  
  let(:website) { FactoryGirl.create(:website) }

  describe "ActiveModel validations" do
    it { expect(website).to validate_presence_of(:url) }
    it { expect(website).to_not allow_value("website").for(:url) }
  end

  describe "URLs" do
    it "should accept valid URLs" do
       urls = %w[http://www.foobar.com http://www.google.com https://google.com/]
        urls.each do |valid_urls|
            website.url = valid_urls
            expect(website).to be_valid
        end 
    end

    it "should not accept invalid URLs" do
      urls = %w[www.foobar.d ftp://google.com http:/google.com/:80]
      urls.each do |invalid_urls|
        website.url = invalid_urls
        expect(website).to_not be_valid
      end
    end
  end
end
