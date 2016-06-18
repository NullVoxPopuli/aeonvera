class Sponsorship < ActiveRecord::Base
  belongs_to :sponsor, polymorphic: true
  belongs_to :sponsored, polymorphic: true

  validates :sponsor, presence: true
  validates :sponsored, presence: true
  validates :discount_amount, numericality: { greater_than_or_equal_to: 0 }
end
