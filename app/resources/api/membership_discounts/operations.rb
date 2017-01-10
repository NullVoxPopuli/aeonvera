module Api
  module MembershipDiscountOperations
    class ReadAll < SkinnyControllers::Operation::Base
      include HelperOperations::Helpers

      def run
        host = host_from_params(params)
        instance_exec(host.membership_discounts, &SkinnyControllers.search_proc)
      end
    end
  end
end
