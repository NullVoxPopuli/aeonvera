# frozen_string_literal: true
module Api
  module PublicAttributes
    module CustomFieldAttributes
      extend ActiveSupport::Concern

      included do
        attributes :id, :label, :kind, :default_value, :editable

        belongs_to :host
      end
    end
  end
end
