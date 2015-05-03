module PackagesHelper

	def current_price_help
		msg = "This is calculated based on the initial price and the teir scheme."
		tooltip_tag(msg)
	end

	def package_menu_options(package)
		dropdown_options(
			links: [
				{
					name: "Registrants",
					path: hosted_event_package_path(@event, package)
				},
				{
					name: "Edit",
					path: hosted_event_package_path(@event, package)
				},
				{
					name: "Destroy",
					path: hosted_event_package_path(@event, package),
					options: {
						method: :delete,
						confirm: "Are you sure?"
					}
				}
			]
		)
	end

end
