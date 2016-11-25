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

class LineItem::Lesson < LineItem
  include Recurrable

  validates :price, presence: true
end
