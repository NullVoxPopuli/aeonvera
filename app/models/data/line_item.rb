# frozen_string_literal: true

# == Schema Information
#
# Table name: line_items
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  price                  :decimal(, )
#  host_id                :integer
#  deleted_at             :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  item_type              :string(255)
#  picture_file_name      :string(255)
#  picture_content_type   :string(255)
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  reference_id           :integer
#  metadata               :text
#  expires_at             :datetime
#  host_type              :string(255)
#  description            :text
#  schedule               :text
#  starts_at              :time
#  ends_at                :time
#  duration_amount        :integer
#  duration_unit          :integer
#  registration_opens_at  :datetime
#  registration_closes_at :datetime
#  becomes_available_at   :datetime
#  initial_stock          :integer          default(0), not null
#
# Indexes
#
#  index_line_items_on_host_id_and_host_type                (host_id,host_type)
#  index_line_items_on_host_id_and_host_type_and_item_type  (host_id,host_type,item_type)
#

class LineItem < ApplicationRecord
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

  alias registrations purchasers

  alias_attribute :current_price, :price

  has_attached_file :picture,
                    preserve_files: true,
                    keep_old_files: true,
                    path: '/assets/:class/:id/picture_:style.:extension',
                    styles: {
                      thumb: '128x128>',
                      medium: '300x300>'
                    }

  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  # validates_attachment_file_name :picture, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/]

  scope :active, -> {
    time = Time.now
    expires_at = arel_table[:expires_at]
    becomes_available_at = arel_table[:becomes_available_at]

    where(
      expires_at.gt(time).or(expires_at.eq(nil))
    ).where(
      becomes_available_at.lt(time).or(becomes_available_at.eq(nil))
    )
  }

  def expired?
    Time.now > expires_at
  end
end
