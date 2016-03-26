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
    include Helpers

    def run
      modify! if alloed_to_modify?

      model
    end

    def modify!
      # nothing on the actual order object itself can change in this step
      

      # next, figure out how to determine what was added and what was removed
      binding.pry
      2+2
    end

    def allowed_to_modify?
      # need to check if this token is present in the params
      unloggedin_token = params[:order][:paymentToken]
      actual_token = model.payment_token

      allowed? || unloggedin_token == actual_token
    end

  end
end
