# frozen_string_literal: true
module Api
  # object is actually an Attendance in this serializer
  class LineItem::ShirtSerializer < ::Api::ShirtSerializer
    type 'shirt'
  end
end
