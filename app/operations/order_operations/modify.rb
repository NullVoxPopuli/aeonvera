module OrderOperations
  # slightly different from update, in that it, like create,
  # doesn't take a JSON API formatted set of parameters.
  #
  # This is triggered by:
  # PUT /api/orders/:id/modify
  #
  # If someone wants to change their order after clicking checkout
  # (and thus the order is created), they click the back button to
  # edit can may perform whatever edits.
  #
  # This will get sligtly complicated, as it will need to detect
  # which order line items are being added, which are being removed,
  # and which are being modified.
  class Modify < SkinnyControllers::Operation::Base

    def run
      modify!

      model
    end

    def modify!
      # TODO: abstract common logic out of create into a module to include here
    end

  end
end
