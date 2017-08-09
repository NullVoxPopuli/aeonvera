# frozen_string_literal: true

# == Schema Information
#
# Table name: sponsorships
#
#  id             :integer          not null, primary key
#  sponsor_id     :integer
#  sponsor_type   :string
#  sponsored_id   :integer
#  sponsored_type :string
#  discount_id    :integer
#  discount_type  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_sponsorships_on_discount_id_and_discount_type    (discount_id,discount_type)
#  index_sponsorships_on_sponsor_type_and_sponsor_id      (sponsor_type,sponsor_id)
#  index_sponsorships_on_sponsored_type_and_sponsored_id  (sponsored_type,sponsored_id)
#

class Sponsorship < ApplicationRecord
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
