# frozen_string_literal: true

module Api
  class ApplicationPresenter
    attr_reader :object

    def initialize(object)
      @object = object
    end
  end
end
