module HasMetadata
  extend ActiveSupport::Concern

  included do
    serialize :metadata, JSON

    after_initialize :prepare_metadata
  end

  def metadata_safe
    self.metadata || {}
  end

  private

  def prepare_metadata
    self.metadata ||= {}
  end

end
