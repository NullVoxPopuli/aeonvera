class Sponsorship < ActiveRecord::Base
  belongs_to :sponsor, polymorphic: true
  belongs_to :sponsored, polymorphic: true
  belongs_to :discount, polymorphic: true

  validates :sponsor, presence: true
  validates :sponsored, presence: true
  validates :discount, presence: true
  validate :discount_belongs_to_sponsored

  private

  def discount_belongs_to_sponsored
    return true if discount && discount.event == sponsored

    errors.add(:discount, 'must belong to the event')
  end
end
