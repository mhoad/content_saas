class Invitation < ApplicationRecord
  belongs_to :account
  delegate :name, :subdomain, :to => :account, :prefix => true

  validates :email, presence: true

  before_create :generate_token

  def to_param
    token
  end

  private

    def generate_token
      self.token = SecureRandom.hex(16)
    end
end
