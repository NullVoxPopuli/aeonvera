class LineItem < ActiveRecord::Base
  self.inheritance_column = "item_type"

  include SoftDeletable
  include HasMetadata

  belongs_to :host, polymorphic: true
  # TODO:
  # belongs_to :reference, polymorphic: true
  belongs_to :organization, class_name: Organization.name,
    foreign_key: "host_id", foreign_type: "host_type", polymorphic: true

  belongs_to :event, class_name: Event.name,
    foreign_key: "host_id", foreign_type: "host_type", polymorphic: true

  has_many :order_line_items, as: :line_item
  # TODO: figure how to get this to evaluate upon
  # inheritance
  # has_many :order_line_items, -> {
  #   where(line_item_type: self.name)
  # }, foreign_key: :line_item_id


  has_many :attendance_line_items
  has_many :attendances,
    -> { where(attending: true).order("attendances.created_at DESC") },
    through: :attendance_line_items

  alias_attribute :current_price, :price

  has_attached_file :picture,
  	path: "/assets/:class/:id/picture_:style.:extension",
	  styles: {
	    thumb: '128x128>',
	    medium: '300x300>'
	  }

    validates_attachment_file_name :picture, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]


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
