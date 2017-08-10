# frozen_string_literal: true

module Api
  class ApplicationPresenter < SimpleDelegator
    attr_reader :object

    def initialize(object)
      super(object)

      @object = object
    end
  end
end
