# frozen_string_literal: true
class LineItem < ActiveRecord::Base
  self.inheritance_column = 'item_type'

  include SoftDeletable
  include HasMetadata
  include Purchasable

  validates :name, presence: true

  belongs_to :host, polymorphic: true

  belongs_to :organization, class_name: Organization.name,
                            foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true

  belongs_to :event, class_name: Event.name,
                     foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true

  alias attendances purchasers

  alias_attribute :current_price, :price

  has_attached_file :picture,
    preserve_files: true,
    path: '/assets/:class/:id/picture_:style.:extension',
    styles: {
      thumb: '128x128>',
      medium: '300x300>'
    }

  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  # validates_attachment_file_name :picture, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/]

  scope :active, ->{
    time = Time.now
    expires_at = arel_table[:expires_at]
    becomes_available_at = arel_table[:becomes_available_at]

    where(
      expires_at.gt(time).or(expires_at.eq(nil))
    ).where(
      becomes_available_at.lt(time).or(becomes_available_at.eq(nil))
    )
  }
end
