class LineItem < ActiveRecord::Base
  self.inheritance_column = "item_type"

  include SoftDeletable
  include HasMetadata

  belongs_to :host, polymorphic: true

  belongs_to :organization, class_name: Organization.name,
    foreign_key: "host_id", foreign_type: "host_type", polymorphic: true

  belongs_to :event, class_name: Event.name,
    foreign_key: "host_id", foreign_type: "host_type", polymorphic: true


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


  scope :active, ->{ where("expires_at > ? OR expires_at IS NULL", Time.now) }

end
