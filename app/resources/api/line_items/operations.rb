# frozen_string_literal: true
module LineItemOperations
  class ReadAll < SkinnyControllers::Operation::Base
    include HelperOperations::Helpers

    def run
      host = host_from_params(params)
      instance_exec(host.line_items, &SkinnyControllers.search_proc)
    end
  end
end
