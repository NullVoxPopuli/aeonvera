# frozen_string_literal: true
module HasLogo
  extend ActiveSupport::Concern

  included do
    has_attached_file :logo,
      preserve_files: true,
      path: '/assets/:class/:id/logo_:style.:extension',
      styles: {
        thumb: '128x128>',
        medium: '300x300>'
      }

    validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
    # do_not_validate_attachment_file_type :logo
    # validates_attachment_file_name :logo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]
  end
end
