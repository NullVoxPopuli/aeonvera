# frozen_string_literal: true

module AeonVera
  module Errors
    class BeforeHookFailed < StandardError; end
    class IncorrectPolicyCheck < StandardError; end
    class DiscountNotFound < StandardError; end
  end
end
