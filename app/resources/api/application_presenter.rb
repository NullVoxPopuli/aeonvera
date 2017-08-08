# frozen_string_literal: true

module Api
  class ApplicationPresenter < SimpleDelegator
    attr_reader :object

    def initialize(object)
      @object = object

      super(object)
    end
  end
end
