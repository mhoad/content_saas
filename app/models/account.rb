class Account < ActiveRecord::Base
  validates :subdomain, presence: true, uniqueness: true
  validates_exclusion_of :subdomain, in: %w( admin help support ), message: "Please pick another subdomain"
  
  belongs_to :owner, class_name: "User"
  accepts_nested_attributes_for :owner
end
