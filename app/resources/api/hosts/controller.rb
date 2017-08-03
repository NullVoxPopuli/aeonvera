# frozen_string_literal: true

module Api
  class HostsController < APIController
    SHARED_RELATIONSHIPS       = 'integrations,'
    EVENT_RELATIONSHIPS        = 'opening_tier,current_tier,custom_fields,line_items,shirts,packages,levels,competitions,sponsorships,sponsorships.discount,sponsorships.sponsor'
    ORGANIZATION_RELATIONSHIPS = 'lessons,membership_options,membership_discounts'
    PUBLIC_EVENT_FIELDS = {
      event: EventFields::PUBLIC_FIELDS,
      integrations: IntegrationSerializer::PUBLIC_FIELDS,
      opening_tier: PricingTierSerializer::PUBLIC_FIELDS,
      current_tier: PricingTierSerializer::PUBLIC_FIELDS,
      custom_fields: CustomFieldSerializer::PUBLIC_FIELDS,
      line_items: LineItemSerializer::PUBLIC_FIELDS,
      shirts: ShirtSerializer::PUBLIC_FIELDS,
      packages: PackageSerializer::PUBLIC_FIELDS,
      levels: LevelFields::PUBLIC_FIELDS,
      competitions: CompetitionSerializer::PUBLIC_FIELDS
      # sponsorships: merged_fieldset(SponsorshipSerializer::PUBLIC_FIELDS, {
      #                                 discount: DiscountSerializer::PUBLIC_FIELDS,
      #                                 sponsor: [:id, :name]
      #                               })
    }.freeze

    before_action :ensure_host

    # TODO: is this ever used?
    def index
      render json: success([host_from_subdomain], class: each_serializer)
    end

    def show
      render json: success(host_from_subdomain,
                           include: include_string,
                           fields: fields,
                           class: each_serializer)
    end

    private

    def ensure_host
      not_found(:subdomain) unless host_from_subdomain
    end

    def host_from_subdomain
      @host ||= HostOperations::Read.new(current_user, host_params).run
    end

    def host_params
      params.permit(:subdomain)
    end

    def each_serializer
      klass = host_from_subdomain.class

      if klass == Event
        EventSerializableResource
      else
        OrganizationSerializableResource
      end
    end

    # this is every possible relationship that the front-end could need when
    # trying to register someone this should all be publicly viewable data.
    #
    # Reguardless of using RegisterEventSerializer or OrganizationSerializer,
    # no personal information should be disclosed, unless it's the
    # current user's personal information.... and only disclosed to the
    # current user. No one else.
    # (though, the TOS to say that registration information is exposed
    #  to event organizers.)
    def include_string
      klass = host_from_subdomain.class
      SHARED_RELATIONSHIPS + (
        if klass == Organization
          ORGANIZATION_RELATIONSHIPS
        else
          EVENT_RELATIONSHIPS
        end
      )
    end

    def fields
      klass = host_from_subdomain.class
      if klass == Organization
        {}
      else
        PUBLIC_EVENT_FIELDS
      end
    end
  end
end
