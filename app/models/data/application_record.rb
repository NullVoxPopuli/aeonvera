# frozen_string_literal: true
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # TODO: remove AR monkey-patch in config/initializers
  def has_errors?
    !errors.empty?
  end

  # TODO: remove AR monkey-patch in config/initializers
  #
  # Thread safe approach to disabling timestamp updates.
  # Useful when we need to modify data without altering updated_at.
  # http://blog.bigbinary.com/2009/01/21/override-automatic-timestamp-in-activerecord-rails.html
  def save_without_timestamping(options = {})
    class << self
      def record_timestamps
        false
      end
    end

    save(options)

    class << self
      remove_method :record_timestamps
    end
  end
end
