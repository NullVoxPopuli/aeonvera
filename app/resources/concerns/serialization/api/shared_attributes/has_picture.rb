# frozen_string_literal: true

module Api
  module SharedAttributes
    module HasPicture
      extend ActiveSupport::Concern

      included do
        attribute(:picture_url) { @object.picture.url(:original) }
        attribute(:picture_url_thumb) { @object.picture.url(:thumb) }
        attribute(:picture_url_medium) { @object.picture.url(:medium) }
      end
    end
  end
end
