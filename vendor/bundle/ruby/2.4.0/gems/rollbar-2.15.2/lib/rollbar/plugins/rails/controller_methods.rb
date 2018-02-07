require 'rollbar/request_data_extractor'

module Rollbar
  module Rails
    module ControllerMethods
      include RequestDataExtractor

      def rollbar_person_data
        user = send(Rollbar.configuration.person_method)
        # include id, username, email if non-empty
        if user
          {
            :id => (user.send(Rollbar.configuration.person_id_method) rescue nil),
            :username => (user.send(Rollbar.configuration.person_username_method) rescue nil),
            :email => (user.send(Rollbar.configuration.person_email_method) rescue nil)
          }
        else
          {}
        end
      rescue NoMethodError, NameError
        {}
      end

      def rollbar_request_data
        extract_request_data_from_rack(request.env)
      end

      # for backwards compatabilty with the old ratchetio-gem
      def ratchetio_person_data
        rollbar_person_data
      end

      # for backwards compatabilty with the old ratchetio-gem
      def ratchetio_request_data
        rollbar_request_data
      end
    end
  end
end
