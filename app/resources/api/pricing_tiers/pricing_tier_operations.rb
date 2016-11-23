module Api
  module PricingTierOperations
    class Create < SkinnyControllers::Operation::Base

      def run
        pricing_tier = PricingTier.new(model_params)

        if allowed_for?(pricing_tier)
          pricing_tier.save
        else
          pricing_tier.errors.add(:base, 'not authorized')
        end

        pricing_tier
      end
    end

    class Update < SkinnyControllers::Operation::Base

      def run
        if allowed?
          update
        else
          (model.presence || PricingTier.new).errors.add(:base, 'not authorized')
        end

        model
      end

      def update
        pricing_tier = model
        pricing_tier.update(model_params)
        pricing_tier
      end

    end

  end
end
