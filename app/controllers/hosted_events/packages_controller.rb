class HostedEvents::PackagesController < ApplicationController
	include SetsEvent
	include LazyCrud

	set_resource Package
	set_resource_parent Event
	set_param_whitelist(
		:name,
		:requires_track,
		:initial_price,
		:at_the_door_price,
		:expires_at,
		:attendee_limit,
		:ignore_pricing_tiers
	)

	layout "edit_event"

end
