module Api
  module SharedAttributes
    module HasLogo
      extend ActiveSupport::Concern

      included do
        attribute(:logo_url) { @object.logo.url(:original) }
        attribute(:logo_url_thumb) { @object.logo.url(:thumb) }
        attribute(:logo_url_medium) { @object.logo.url(:medium) }
      end
    end
  end
end
