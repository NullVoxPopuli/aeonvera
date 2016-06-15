class Sponsorship < ActiveRecord::Base
  belongs_to :sponsor, polymorphic: true
  belongs_to :sponsored, polymorphic: true

  validates :sponsor, presence: true
  validates :sponsored, presence: true
end
