class HousingProvision < ActiveRecord::Base
  include CSVOutput

  belongs_to :host, polymorphic: true
  belongs_to :attendance, -> { with_deleted }, polymorphic: true
  belongs_to :event, class_name: Event.name,
    foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true


  has_many :housing_requests
end
