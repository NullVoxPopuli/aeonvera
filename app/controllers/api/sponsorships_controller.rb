module Api
  class SponsorshipsController < Api::ResourceController
    before_filter :must_be_logged_in, except: [:index]

    private

    def update_sponsorship_params
      whitelistable_params(polymorphic: [
        :sponsor, :sponsored, :discount
        ]) do |whitelister|
        whitelister.permit(
          :sponsor_id, :sponsor_type,
          :sponsored_id, :sponsored_type,
          :discount_id, :discount_type
        )
      end
    end

    def create_sponsorship_params
      update_sponsorship_params
    end
  end
end
