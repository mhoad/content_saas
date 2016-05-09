class Account < ActiveRecord::Base
  validates :subdomain, presence: true, uniqueness: true
  validates_exclusion_of :subdomain, in: %w( admin help support ), message: "Please pick another subdomain"
  
  belongs_to :plan
  belongs_to :owner, class_name: "User"
  accepts_nested_attributes_for :owner

  has_many :invitations
  has_many :memberships
  has_many :users, through: :memberships
  has_many :websites
  
  def subscribed?
    stripe_subscription_id.present?
  end
  
  def over_limit_for?(plan)
    websites.count > plan.websites_allowed
  end
end
