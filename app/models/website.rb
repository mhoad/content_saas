class Website < ApplicationRecord
  belongs_to :account
  # Not convinced this regex is the best
  validates_presence_of :url
  validates_format_of :url, :with => /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
end
